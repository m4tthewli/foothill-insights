-- ============================================================
-- Foothill Insights — Supabase database setup
-- Run this entire file in your Supabase SQL Editor
-- Dashboard → SQL Editor → New query → paste → Run
-- ============================================================

-- 1. Create the submissions table
create table if not exists public.submissions (
  id            bigserial primary key,
  created_at    timestamptz default now() not null,

  term          text,
  year_in_school text,
  major         text,          -- 'stem' | 'arts' | 'mixed'
  course_load   integer,       -- number of courses taken
  courses       text,          -- comma-separated list of course codes
  hours         integer,       -- weekly study hours
  stress        integer,       -- 1-10
  gpa           numeric(3,1),  -- null if student preferred not to say
  dropped       integer default 0, -- 0 | 1 | 2+
  helpers       text,          -- comma-separated list of what helped
  advice        text           -- free-text advice (nullable)
);

-- 2. Enable Row Level Security
alter table public.submissions enable row level security;

-- 3. Allow anyone to INSERT (anonymous submissions)
create policy "Allow anonymous insert"
  on public.submissions
  for insert
  to anon
  with check (true);

-- 4. Allow anyone to SELECT (public read for dashboard)
create policy "Allow public read"
  on public.submissions
  for select
  to anon
  using (true);

-- 5. Index for fast dashboard queries
create index if not exists submissions_major_idx  on public.submissions(major);
create index if not exists submissions_term_idx   on public.submissions(term);
create index if not exists submissions_created_idx on public.submissions(created_at desc);

-- ============================================================
-- OPTIONAL: Seed some sample data to start with
-- Uncomment and run if you want data visible before real submissions
-- ============================================================

/*
insert into public.submissions (term, year_in_school, major, course_load, courses, hours, stress, gpa, dropped, helpers, advice)
values
  ('Spring 2025', '1st year', 'stem', 3, 'CS 1A, Math 1A, Engl 1A', 18, 8, 3.0, 0, 'Study groups, Office hours', 'CS 1A and Math 1A together is rough. Start early on everything.'),
  ('Spring 2025', '2nd year', 'stem', 2, 'CS 1B, Math 1B', 14, 7, 3.3, 0, 'Tutoring center, Friends in class', null),
  ('Spring 2025', '1st year', 'arts', 3, 'Engl 1A, Hist 17A, Psych 1', 9, 4, 3.8, 0, 'Good sleep schedule', 'Very manageable combo. Great for first term.'),
  ('Spring 2025', 'Transfer student', 'mixed', 4, 'CS 1A, Econ 1A, Engl 1A, Math 1A', 22, 9, 2.7, 1, 'Office hours', 'Do not take 4 courses your first term. I dropped one.'),
  ('Spring 2025', '2nd year', 'stem', 3, 'Chem 1A, Bio 10, Math 1B', 16, 7, 3.1, 0, 'Study groups, Online resources', null);
*/
