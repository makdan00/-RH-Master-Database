import uuid
import random
from datetime import datetime, timedelta

# Configuration for the challenge requirements
NUM_PARTICIPANTS = 100
NUM_JUDGES = 10
NUM_ADMINS = 5
NUM_SUBMISSIONS = 75
NUM_EVALUATIONS = 40

# Sample data pools for realism
TECH_STACKS = ['React', 'PostgreSQL', 'Python', 'Node.js', 'Next.js', 'FastAPI', 'AWS', 'Docker']
NAMES = ["James", "Mary", "Robert", "Patricia", "John", "Jennifer", "Michael", "Linda"]
SURNAMES = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller"]

def generate_full_name():
    return f"{random.choice(NAMES)} {random.choice(SURNAMES)}"

sql_statements = ["-- Remote Hustle Master Seed Data"]

# 1. Generate Users (Admins, Judges, Participants)
user_ids, participant_ids, judge_ids, admin_ids = [], [], [], []

for i in range(NUM_ADMINS):
    uid = str(uuid.uuid4())
    sql_statements.append(f"INSERT INTO users (id, full_name, email, role) VALUES ('{uid}', '{generate_full_name()}', 'admin{i}@rh.com', 'admin');")
    admin_ids.append(uid)

for i in range(NUM_JUDGES):
    uid = str(uuid.uuid4())
    sql_statements.append(f"INSERT INTO users (id, full_name, email, role) VALUES ('{uid}', '{generate_full_name()}', 'judge{i}@rh.com', 'judge');")
    judge_ids.append(uid)

for i in range(NUM_PARTICIPANTS):
    uid = str(uuid.uuid4())
    sql_statements.append(f"INSERT INTO users (id, full_name, email, role) VALUES ('{uid}', '{generate_full_name()}', 'user{i}@example.com', 'participant');")
    participant_ids.append(uid)

# 2. Generate Profiles for Participants
for pid in participant_ids:
    github = f"https://github.com/dev-{pid[:5]}"
    stacks = "ARRAY" + str(random.sample(TECH_STACKS, 2)).replace("[", "['").replace("]", "']").replace(", ", "', '")
    sql_statements.append(f"INSERT INTO profiles (user_id, github_handle, tech_stack, bio) VALUES ('{pid}', '{github}', {stacks}, 'I love building systems.');")

# 3. Setup Stages & Challenges
sql_statements.append("INSERT INTO stages (id, name, start_date, end_date) VALUES (1, 'Stage 1: Operation Master', '2023-10-01', '2023-10-07');")
sql_statements.append("INSERT INTO challenges (id, stage_id, title, due_date) VALUES (1, 1, 'Build the DB', '2023-10-07 23:59:59');")

# 4. Generate Submissions
submission_ids = []
for pid in random.sample(participant_ids, NUM_SUBMISSIONS):
    sid = str(uuid.uuid4())
    sql_statements.append(f"INSERT INTO submissions (id, participant_id, challenge_id, repo_url, status) VALUES ('{sid}', '{pid}', 1, 'https://github.com/rh/{sid[:5]}', 'completed');")
    submission_ids.append(sid)

# 5. Generate Evaluations
for i in range(NUM_EVALUATIONS):
    sid = random.choice(submission_ids)
    jid = random.choice(judge_ids)
    sql_statements.append(f"INSERT INTO evaluations (id, submission_id, judge_id, score, feedback) VALUES ('{str(uuid.uuid4())}', '{sid}', '{jid}', {random.randint(70, 100)}, 'Great operational logic.');")

# Output to file
with open('seed_data.sql', 'w') as f:
    f.write("\n".join(sql_statements))

print("Seed file 'seed_data.sql' created successfully!")
