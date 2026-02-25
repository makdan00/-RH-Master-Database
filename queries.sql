-- Query 1: Get all participants
SELECT * FROM users WHERE role = 'participant';

-- Query 2: Find submissions waiting for a grade
SELECT * FROM submissions WHERE status = 'pending';

-- Query 3: Show the Top 10 Leaders
SELECT * FROM leaderboard LIMIT 10;

-- Query 4: Show Judge workloads
SELECT judge_id, COUNT(*) FROM evaluations GROUP BY judge_id;

-- Query 5: Find late submissions
SELECT s.* FROM submissions s JOIN challenges c ON s.challenge_id = c.id WHERE s.submitted_at > c.due_date;

-- Query 6: Audit Check (Last 10 actions)
SELECT * FROM audit_logs ORDER BY changed_at DESC LIMIT 10;

-- Query 7: Participants by Tech Stack
SELECT unnest(tech_stack), count(*) FROM profiles GROUP BY 1;

-- Query 8: Full history of one student
SELECT * FROM submissions WHERE participant_id = 'INSERT_ID_HERE';
