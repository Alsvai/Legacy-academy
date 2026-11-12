-- The Legacy Academy : base partagée pour les lignées
-- À exécuter dans Supabase > SQL Editor.
create table if not exists public.parents (
  name text primary key,
  origin text not null default '',
  category text not null default '',
  story text not null default '',
  personality text not null default '',
  powers jsonb not null default '[]'::jsonb,
  secondary jsonb not null default '[]'::jsonb,
  weaknesses jsonb not null default '[]'::jsonb,
  traits jsonb not null default '[]'::jsonb,
  children integer not null default 0 check (children between 0 and 3),
  available boolean not null default true,
  random boolean not null default true,
  updated_at timestamptz not null default now()
);

alter table public.parents enable row level security;

drop policy if exists "Parents visibles publiquement" on public.parents;
create policy "Parents visibles publiquement"
on public.parents for select
to anon, authenticated
using (true);

drop policy if exists "Staff peut ajouter les lignées" on public.parents;
create policy "Staff peut ajouter les lignées"
on public.parents for insert
to authenticated
with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'staff');

drop policy if exists "Staff peut modifier les lignées" on public.parents;
create policy "Staff peut modifier les lignées"
on public.parents for update
to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'staff')
with check ((auth.jwt() -> 'app_metadata' ->> 'role') = 'staff');

drop policy if exists "Staff peut supprimer les lignées" on public.parents;
create policy "Staff peut supprimer les lignées"
on public.parents for delete
to authenticated
using ((auth.jwt() -> 'app_metadata' ->> 'role') = 'staff');

grant select on public.parents to anon, authenticated;
grant insert, update, delete on public.parents to authenticated;
