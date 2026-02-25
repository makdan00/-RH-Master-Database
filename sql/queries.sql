-- 1. PARTICIPANT REGISTRATION & PROFILES
-- Gets all participants along with their tech stack and bio
SELECT u.full_name, u.email, p.tech_stack, p.github_handle 
FROM users u 
JOIN profiles p ON u.id = p.user_id 
WHERE u.role = 'participant';

-- 2. SUBMISSION TRACKING
-- Shows all submissions that are waiting to be graded
SELECT s.submitted_at, u.full_name, c.title, s.repo_url 
FROM submissions s
JOIN users u ON s.participant_id = u.id
JOIN challenges c ON s.challenge_id = c.id
WHERE s.status = 'pending';

-- 3. JUDGE SCORING
-- Shows a list of scores given by a specific judge
SELECT u.full_name AS judge_name, e.score, e.feedback 
FROM evaluations e
JOIN users u ON e.judge_id = u.id;

-- 4. STAGE PROGRESSION
-- Identifies participants who scored > 80 to move to the next stage
SELECT u.full_name, AVG(e.score) as avg_score
FROM users u
JOIN submissions s ON u.id = s.participant_id
JOIN evaluations e ON s.id = e.submission_id
GROUP BY u.full_name
HAVING AVG(e.score) >= 80;

-- 5. REPORTS & ANALYTICS
-- Shows which tech stacks are most popular among participants
SELECT unnest(tech_stack) AS skill, COUNT(*) 
FROM profiles 
GROUP BY skill 
ORDER BY COUNT(*) DESC;

-- 6. AUDIT LOGS
-- Shows the most recent 10 administrative actions for security
SELECT * FROM audit_logs 
ORDER BY changed_at DESC 
LIMIT 10;

-- 7. DEADLINE CHECK
-- Lists participants who submitted after the challenge due date
SELECT u.full_name, s.submitted_at, c.due_date
FROM submissions s
JOIN users u ON s.participant_id = u.id
JOIN challenges c ON s.challenge_id = c.id
WHERE s.submitted_at > c.due_date;

-- 8. JUDGE WORKLOAD
-- Counts how many evaluations each judge has completed
SELECT u.full_name, COUNT(e.id) as reviews_done
FROM users u
LEFT JOIN evaluations e ON u.id = e.judge_id
WHERE u.role = 'judge'
GROUP BY u.full_name;

-- 9. LEADERBOARD
-- Show the top 10 leaders
SELECT * 
FROM leaderboard 
LIMIT 10;
