-- 1. Users Table (The Master List)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT CHECK (role IN ('admin', 'judge', 'participant')),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Participant Profiles (The Bio/GitHub Info)
CREATE TABLE profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    github_handle TEXT,
    tech_stack TEXT[],
    bio TEXT
);

-- 3. Stages Table (The Competition Phases)
CREATE TABLE stages (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    start_date DATE,
    end_date DATE
);

-- 4. Challenges Table (The Homework Tasks)
CREATE TABLE challenges (
    id SERIAL PRIMARY KEY,
    stage_id INTEGER REFERENCES stages(id),
    title TEXT NOT NULL,
    due_date TIMESTAMPTZ
);

-- 5. Submissions Table (What Students Turn In)
CREATE TABLE submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    participant_id UUID REFERENCES users(id),
    challenge_id INTEGER REFERENCES challenges(id),
    repo_url TEXT NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'under_review', 'completed')),
    submitted_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Evaluations Table (The Grades)
CREATE TABLE evaluations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submission_id UUID REFERENCES submissions(id) ON DELETE CASCADE,
    judge_id UUID REFERENCES users(id),
    score INTEGER CHECK (score >= 0 AND score <= 100),
    feedback TEXT,
    evaluated_at TIMESTAMPTZ DEFAULT now()
);

-- 7. Audit Logs (The Security Camera)
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    action TEXT NOT NULL,
    table_name TEXT,
    actor_id UUID REFERENCES users(id),
    changed_at TIMESTAMPTZ DEFAULT now()
);

-- 8. Leaderboard (The Smart Ranker)
CREATE OR REPLACE VIEW leaderboard AS
SELECT 
    u.full_name,
    AVG(e.score) as average_score
FROM users u
JOIN submissions s ON u.id = s.participant_id
JOIN evaluations e ON s.id = e.submission_id
GROUP BY u.full_name
ORDER BY average_score DESC;
