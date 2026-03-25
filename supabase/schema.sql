-- Enable extensions
create extension if not exists "uuid-ossp";

-- Profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

-- Meal entries
create table if not exists public.meal_entries (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  captured_at timestamptz not null default now(),
  meal_type text not null check (meal_type in ('breakfast', 'lunch', 'dinner', 'snack')),
  image_url text,
  foods jsonb not null default '[]'::jsonb,
  nutrition jsonb not null,
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists meal_entries_user_captured_idx
  on public.meal_entries (user_id, captured_at desc);

-- RLS
alter table public.profiles enable row level security;
alter table public.meal_entries enable row level security;

create policy "Profiles are self readable"
on public.profiles for select
using (auth.uid() = id);

create policy "Profiles are self writable"
on public.profiles for all
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can read own meals"
on public.meal_entries for select
using (auth.uid() = user_id);

create policy "Users can insert own meals"
on public.meal_entries for insert
with check (auth.uid() = user_id);

create policy "Users can update own meals"
on public.meal_entries for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "Users can delete own meals"
on public.meal_entries for delete
using (auth.uid() = user_id);
