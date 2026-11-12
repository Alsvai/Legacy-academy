-- The Legacy Academy — sécurité de l'espace staff
-- À exécuter dans Supabase > SQL Editor.
-- Ne jamais mettre la clé service_role dans le site web.

create table if not exists public.staff_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'staff' check (role in ('admin','staff')),
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.staff_members enable row level security;

-- Chaque membre ne peut consulter que sa propre ligne ; aucun visiteur anonyme
-- ne peut lister les comptes du staff.
create policy "staff can read own membership"
on public.staff_members for select
to authenticated
using (user_id = auth.uid());

-- Table de demandes partagées. Les visiteurs peuvent envoyer une demande,
-- mais seul un membre actif du staff peut les lire et les traiter.
create table if not exists public.reservation_requests (
  id uuid primary key default gen_random_uuid(),
  player_name text not null check (char_length(player_name) between 1 and 80),
  parent_name text not null check (char_length(parent_name) between 1 and 120),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now(),
  reviewed_by uuid references auth.users(id),
  reviewed_at timestamptz
);

alter table public.reservation_requests enable row level security;

create policy "visitors can submit reservation requests"
on public.reservation_requests for insert
to anon, authenticated
with check (status = 'pending' and reviewed_by is null and reviewed_at is null);

create policy "active staff can read reservation requests"
on public.reservation_requests for select
to authenticated
using (exists (select 1 from public.staff_members s where s.user_id = auth.uid() and s.active = true));

create policy "active staff can review reservation requests"
on public.reservation_requests for update
to authenticated
using (exists (select 1 from public.staff_members s where s.user_id = auth.uid() and s.active = true))
with check (exists (select 1 from public.staff_members s where s.user_id = auth.uid() and s.active = true));

-- Paramètres du répertoire : lecture publique, écriture staff uniquement.
create table if not exists public.parent_settings (
  parent_name text primary key,
  available boolean not null default true,
  included_in_random boolean not null default true,
  descendant_count integer not null default 0 check (descendant_count between 0 and 3),
  updated_at timestamptz not null default now()
);

alter table public.parent_settings enable row level security;
create policy "everyone can read parent settings"
on public.parent_settings for select to anon, authenticated using (true);
create policy "active staff can insert parent settings"
on public.parent_settings for insert to authenticated
with check (exists (select 1 from public.staff_members s where s.user_id = auth.uid() and s.active = true));
create policy "active staff can update parent settings"
on public.parent_settings for update to authenticated
using (exists (select 1 from public.staff_members s where s.user_id = auth.uid() and s.active = true))
with check (exists (select 1 from public.staff_members s where s.user_id = auth.uid() and s.active = true));
create policy "active staff can delete parent settings"
on public.parent_settings for delete to authenticated
using (exists (select 1 from public.staff_members s where s.user_id = auth.uid() and s.active = true));
