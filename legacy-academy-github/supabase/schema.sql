-- The Legacy Academy — Supabase schema
-- Run this file in Supabase > SQL Editor.

create table if not exists public.staff_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.parent_settings (
  parent_name text primary key,
  children integer not null default 0 check (children between 0 and 3),
  available boolean not null default true,
  random_enabled boolean not null default true,
  updated_at timestamptz not null default now()
);

alter table public.staff_members enable row level security;
alter table public.parent_settings enable row level security;

-- A signed-in user can only read their own staff membership.
drop policy if exists "Staff can read own membership" on public.staff_members;
create policy "Staff can read own membership"
on public.staff_members for select
to authenticated
using (user_id = auth.uid());

-- Public visitors can read parent availability/counts; only staff can change them.
drop policy if exists "Anyone can read parent settings" on public.parent_settings;
create policy "Anyone can read parent settings"
on public.parent_settings for select
to anon, authenticated
using (true);

drop policy if exists "Staff can insert parent settings" on public.parent_settings;
create policy "Staff can insert parent settings"
on public.parent_settings for insert
to authenticated
with check (exists (select 1 from public.staff_members s where s.user_id = auth.uid()));

drop policy if exists "Staff can update parent settings" on public.parent_settings;
create policy "Staff can update parent settings"
on public.parent_settings for update
to authenticated
using (exists (select 1 from public.staff_members s where s.user_id = auth.uid()))
with check (exists (select 1 from public.staff_members s where s.user_id = auth.uid()));

grant select on public.staff_members to authenticated;
grant select on public.parent_settings to anon, authenticated;
grant insert, update on public.parent_settings to authenticated;
