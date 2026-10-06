-- Die Seite ist nicht öffentlich: Beispiel-Lektionen und Testfortschritt werden verworfen.
delete from public.lessons;
drop table public.profiles;

create table public.courses (
  id bigint generated always as identity primary key,
  slug text not null unique check (slug <> ''),
  title text not null check (title <> ''),
  summary text not null check (summary <> ''),
  position integer not null unique,
  recommended_course_id bigint references public.courses (id) on delete set null,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index courses_recommended_course_id_idx on public.courses (recommended_course_id);

create trigger courses_set_updated_at
  before update on public.courses
  for each row execute function public.set_updated_at();

alter table public.lessons
  add column course_id bigint not null references public.courses (id) on delete cascade,
  drop constraint lessons_slug_key,
  drop constraint lessons_position_key,
  add constraint lessons_course_slug_key unique (course_id, slug),
  add constraint lessons_course_position_key unique (course_id, position);

create table public.course_state (
  user_id uuid not null references auth.users (id) on delete cascade,
  course_id bigint not null references public.courses (id) on delete cascade,
  last_lesson_id bigint references public.lessons (id) on delete set null,
  updated_at timestamptz not null default now(),
  primary key (user_id, course_id)
);

create index course_state_course_id_idx on public.course_state (course_id);
create index course_state_last_lesson_id_idx on public.course_state (last_lesson_id);

alter table public.courses enable row level security;
alter table public.course_state enable row level security;

revoke all on public.courses, public.course_state from anon, authenticated;

grant select on public.courses to anon, authenticated;
grant select, insert, update on public.course_state to authenticated;

create policy "Veröffentlichte Kurse sind für alle lesbar"
  on public.courses for select
  to anon, authenticated
  using (published);

drop policy "Veröffentlichte Lektionen sind für alle lesbar" on public.lessons;

create policy "Veröffentlichte Lektionen veröffentlichter Kurse sind für alle lesbar"
  on public.lessons for select
  to anon, authenticated
  using (
    published
    and exists (
      select 1 from public.courses
      where courses.id = lessons.course_id and courses.published
    )
  );

create policy "Eigenen Kursstand lesen"
  on public.course_state for select
  to authenticated
  using (user_id = (select auth.uid()));

create policy "Eigenen Kursstand anlegen"
  on public.course_state for insert
  to authenticated
  with check (user_id = (select auth.uid()));

create policy "Eigenen Kursstand ändern"
  on public.course_state for update
  to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
