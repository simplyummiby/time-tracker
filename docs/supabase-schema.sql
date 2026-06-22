-- Meridian Hub Phase 1/2 Supabase schema
-- Run this in the Supabase SQL editor, then copy the generated company id
-- into SUPABASE_CONFIG.companyId in index.html.

create extension if not exists "pgcrypto";

create table if not exists public.companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.company_members (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member',
  status text not null default 'active',
  created_at timestamptz not null default now(),
  unique (company_id, user_id)
);

create table if not exists public.time_entries (
  id uuid primary key,
  company_id uuid not null references public.companies(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  entry_date date not null,
  project text not null,
  task_type text not null,
  notes text,
  start_time text,
  end_time text,
  raw_start_time text,
  raw_end_time text,
  duration_hours numeric not null default 0,
  entry_type text not null default 'Manual',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.companies enable row level security;
alter table public.company_members enable row level security;
alter table public.time_entries enable row level security;

create policy "Members can read their companies"
  on public.companies for select
  using (exists (
    select 1 from public.company_members cm
    where cm.company_id = companies.id
      and cm.user_id = auth.uid()
      and cm.status = 'active'
  ));

create policy "Members can read company members"
  on public.company_members for select
  using (user_id = auth.uid() or exists (
    select 1 from public.company_members cm
    where cm.company_id = company_members.company_id
      and cm.user_id = auth.uid()
      and cm.status = 'active'
  ));

create policy "Members can read company time entries"
  on public.time_entries for select
  using (exists (
    select 1 from public.company_members cm
    where cm.company_id = time_entries.company_id
      and cm.user_id = auth.uid()
      and cm.status = 'active'
  ));

create policy "Members can insert their own time entries"
  on public.time_entries for insert
  with check (user_id = auth.uid() and exists (
    select 1 from public.company_members cm
    where cm.company_id = time_entries.company_id
      and cm.user_id = auth.uid()
      and cm.status = 'active'
  ));

create policy "Members can update their own time entries"
  on public.time_entries for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "Members can delete their own time entries"
  on public.time_entries for delete
  using (user_id = auth.uid());

-- Bootstrap example after creating at least one auth user:
-- insert into public.companies (name, created_by) values ('Meridian ITP', '<auth-user-id>') returning id;
-- insert into public.company_members (company_id, user_id, role) values ('<company-id>', '<auth-user-id>', 'owner');
