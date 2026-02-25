# RH-Master-Database
## Project Overview
This is a high-performance database designed to run the Remote Hustle Database Challenge (RHDC) without the mess. It replaces slow spreadsheets with a fast, secure, and "smart" system that tracks participants, grades their work, and catches mistakes automatically.
## The Tech Stack (What I used)
Database: PostgreSQL (The "Brain")

Hosting: Supabase (The "Cloud Home")

Data Generation: Python (The "Robot" that made the test data)

Design: Relational Modeling (The "Map")
## How it Works (Simple Explanation)
The Skeleton (Schema): I built 8 specialized tables. For example, the users table holds names, while the evaluations table holds the grades. They are connected by "logic strings" (Foreign Keys) so data never gets mixed up.

The Safety Rails (Constraints): I told the database: "Don't allow scores higher than 100" and "Don't allow two people to use the same email." The database handles the rules so humans don't have to.

The Secret Diary (Audit Logs): Every time a score is added, the database writes it down in a special log. This keeps the competition fair.
## Ready-to-Run Queries (Test it Yourself!)
Copy and paste these into the SQL Editor to see the database in action:

1. The Live Leaderboard
Who is currently winning?
SQL
SELECT * FROM leaderboard;

3. The "To-Do" List for Judges
Which submissions haven't been graded yet?
SQL
SELECT * FROM submissions WHERE status = 'pending';

3. The Audit Trail
Show me the last 10 things that happened in the database.
SQL
SELECT * FROM audit_logs ORDER BY changed_at DESC LIMIT 10;
## How to Connect
You can connect to this database live using the following credentials:

Host: db.xudlymteuuwmaqijmdqe.supabase.co

Port: 5432

User: postgres

Database: postgres

Password: [shared privately]

Database: rh_master_db
## What's in this GitHub?
schema.sql: The code to build the tables from scratch.

seed_data.sql: 300+ rows of realistic data so the database isn't empty.

queries.sql: A list of 8 helpful "questions" the database can answer.

generate.py: Script to generate "seed_data.sql".

ERD_Diagram.png: An image of the database map.

Project_Description.pdf: A short project description.

