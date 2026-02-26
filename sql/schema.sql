-- ==========================================
-- 1. TABLES & CONSTRAINTS
-- ==========================================

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT CHECK (role IN ('admin', 'judge', 'participant')) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Stages Table
CREATE TABLE stages (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Challenges Table
CREATE TABLE challenges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stage_id INTEGER REFERENCES stages(id),
    title TEXT NOT NULL,
    description TEXT,
    due_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Submissions Table
CREATE TABLE submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    participant_id UUID REFERENCES users(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
    repo_url TEXT NOT NULL,
    status TEXT CHECK (status IN ('pending', 'completed', 'reviewed')) DEFAULT 'pending',
    submitted_at TIMESTAMPTZ DEFAULT now()
);

-- Evaluations Table
CREATE TABLE evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID REFERENCES submissions(id) ON DELETE CASCADE,
    judge_id UUID REFERENCES users(id),
    score INTEGER CHECK (score >= 0 AND score <= 100),
    feedback TEXT,
    graded_at TIMESTAMPTZ DEFAULT now()
);

-- Audit Logs Table
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    table_name TEXT,
    action TEXT,
    actor_id UUID,
    changed_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 2. SECURITY HARDENED FUNCTIONS & TRIGGERS
-- ==========================================

-- Function to log actions (Security Hardened with search_path)
CREATE OR REPLACE FUNCTION log_action()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (action, table_name, actor_id)
  VALUES (TG_OP, TG_TABLE_NAME, (SELECT id FROM users WHERE role = 'judge' LIMIT 1));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Attach Triggers
CREATE TRIGGER trg_audit_users
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION log_action();

CREATE TRIGGER trg_audit_submissions
AFTER INSERT OR UPDATE OR DELETE ON submissions
FOR EACH ROW EXECUTE FUNCTION log_action();

-- ==========================================
-- 3. SECURE VIEWS (Leaderboard)
-- ==========================================

CREATE VIEW leaderboard 
WITH (security_invoker = true) AS
SELECT 
    p.full_name,
    SUM(e.score) as total_score,
    RANK() OVER (ORDER BY SUM(e.score) DESC) as rank
FROM users p
JOIN submissions s ON p.id = s.participant_id
JOIN evaluations e ON s.id = e.submission_id
GROUP BY p.full_name;

-- ==========================================
-- 4. ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

-- Enable RLS on all base tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluations ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Create Public Read Policies
CREATE POLICY "Public Read" ON users FOR SELECT USING (true);
CREATE POLICY "Public Read" ON stages FOR SELECT USING (true);
CREATE POLICY "Public Read" ON challenges FOR SELECT USING (true);
CREATE POLICY "Public Read" ON submissions FOR SELECT USING (true);
CREATE POLICY "Public Read" ON evaluations FOR SELECT USING (true);
CREATE POLICY "Public Read" ON audit_logs FOR SELECT USING (true);
