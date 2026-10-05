create table public.lessons (
  id bigint generated always as identity primary key,
  slug text not null unique check (slug <> ''),
  title text not null check (title <> ''),
  summary text not null check (summary <> ''),
  position integer not null unique,
  section text not null check (section in ('start', 'html', 'css', 'js', 'abschluss')),
  content text not null check (content <> ''),
  solution text,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.lesson_progress (
  user_id uuid not null references auth.users (id) on delete cascade,
  lesson_id bigint not null references public.lessons (id) on delete cascade,
  completed_at timestamptz not null default now(),
  primary key (user_id, lesson_id)
);

create index lesson_progress_lesson_id_idx on public.lesson_progress (lesson_id);

create table public.profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  last_lesson_id bigint references public.lessons (id) on delete set null,
  updated_at timestamptz not null default now()
);

create index profiles_last_lesson_id_idx on public.profiles (last_lesson_id);

create function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger lessons_set_updated_at
  before update on public.lessons
  for each row execute function public.set_updated_at();

alter table public.lessons enable row level security;
alter table public.lesson_progress enable row level security;
alter table public.profiles enable row level security;

revoke all on public.lessons, public.lesson_progress, public.profiles from anon, authenticated;

grant select on public.lessons to anon, authenticated;
grant select, insert, delete on public.lesson_progress to authenticated;
grant select, insert, update on public.profiles to authenticated;

create policy "Veröffentlichte Lektionen sind für alle lesbar"
  on public.lessons for select
  to anon, authenticated
  using (published);

create policy "Eigenen Fortschritt lesen"
  on public.lesson_progress for select
  to authenticated
  using (user_id = (select auth.uid()));

create policy "Eigenen Fortschritt anlegen"
  on public.lesson_progress for insert
  to authenticated
  with check (user_id = (select auth.uid()));

create policy "Eigenen Fortschritt löschen"
  on public.lesson_progress for delete
  to authenticated
  using (user_id = (select auth.uid()));

create policy "Eigenes Profil lesen"
  on public.profiles for select
  to authenticated
  using (user_id = (select auth.uid()));

create policy "Eigenes Profil anlegen"
  on public.profiles for insert
  to authenticated
  with check (user_id = (select auth.uid()));

create policy "Eigenes Profil ändern"
  on public.profiles for update
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
