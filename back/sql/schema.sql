
-- Inserts/updates to profiles are done by the backend using the service_role
-- key, which bypasses RLS entirely, so no insert/update policy is required
-- for the app to function. These SELECT policy is kept in case the frontend
-- ever queries Supabase directly in the future.

-- ============================================================
-- reports: one row per submitted repair report ("rapport")
-- ============================================================
create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  technician_id uuid not null references auth.users(id) on delete cascade,
  technician_name text not null,
  machine_code text not null,
  failure_type text not null,
  accepted_at timestamptz not null,
  repair_started_at timestamptz not null,
  repair_ended_at timestamptz not null,
  problem_description text not null,
  solution_applied text not null,
  notes text,
  created_at timestamptz not null default now()
);

alter table public.reports enable row level security;

drop policy if exists "Technicians can view their own reports" on public.reports;
create policy "Technicians can view their own reports"
  on public.reports for select
  using (auth.uid() = technician_id);

-- All reads/writes from the backend go through the service_role key
-- (bypasses RLS), so the app works without any further policies. The
-- policy above just keeps things sane if the frontend ever talks to
-- Supabase directly.

-- ============================================================
-- To make a user an admin after they sign up:
--   Table Editor -> profiles -> find their row -> set role = 'admin'
-- ============================================================
