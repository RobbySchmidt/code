# Mehrere Kurse – Plattform-Umbau: Umsetzungsplan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Die Kursseite von einem einzigen Kurs auf mehrere Kurse umbauen: Kursübersicht, Kursseite, Lektionsadressen mit Kurs im Pfad, Fortschritt und „Kurs weitermachen“ pro Kurs.

**Architecture:** Eine neue Tabelle `courses`, `lessons.course_id` und `course_state` (ersetzt `profiles`) tragen die Struktur; RLS zeigt eine Lektion nur, wenn sie und ihr Kurs veröffentlicht sind. Die Seite lädt alle Kurse und alle Lektionslisten je einmal und ordnet sie mit reinen Funktionen aus `app/utils/courses.js` zu. Die bestehenden Bausteine `LessonList`, `ResumeButton`, `CompleteButton` und `useProgress` bleiben und bekommen den Kurs als Parameter.

**Tech Stack:** Nuxt 4, `@nuxtjs/supabase` 2.x, `@nuxtjs/mdc`, Tailwind 4, Vitest, Supabase CLI.

**Spec:** `docs/superpowers/specs/2026-10-06-mehrere-kurse-design.md` (ergänzt `docs/superpowers/specs/2026-10-05-nuxt-kursseite-design.md`, dessen Abschnitte Gestaltung, Konten und Fehlerfälle weiter gelten)

**Abgrenzung:** Dieser Plan baut die Plattform um und füllt sie mit Beispielkursen. Die echten Kurse „Erste Schritte“ und „Todo-App“ kommen in einem eigenen Plan.

## Global Constraints

- JavaScript mit `<script setup>`, kein TypeScript, in allen `.vue`- und `.js`-Dateien.
- Paketmanager ist yarn 1.x. Shell ist PowerShell 5.1 unter Windows (kein `&&`, Befehle mit `;` verketten).
- Alle sichtbaren Texte sind deutsch und duzen.
- Akzentfarbe ist Ember `#ff5900`: Hauptaktion je Bereich, Fortschrittsbalken, Häkchen, außerdem Menü-Links der Kopfzeile bei Hover und auf der aktiven Seite. Keine zweite Akzentfarbe, auch nicht für Fehler.
- Links im Fließtext: Ink mit Unterstreichung.
- Keine Schatten. Abgrenzung über Paper auf Fog und 1px-Rahmen in Mist.
- Radien: `rounded-xl` für Buttons, Eingabefelder, Karten; `rounded-md` für Etiketten; `rounded-full` nur für runde Markierungen und den Fortschrittsbalken.
- Laufweite −0,01em bis 24px, −0,02em bei 36px, −0,025em bei 48px, −0,03em bei 72px.
- Seite maximal 1200px breit, Fließtext maximal 640px, linksbündig.
- `useSupabaseUser()` liefert JWT-Claims: Die Nutzer-ID steht in `user.value.sub`. Es gibt kein `user.value.id`.
- Dateien in `app/utils/` und `app/composables/` werden von Nuxt automatisch importiert. Utils, die andere Utils brauchen, importieren sie ausdrücklich über relative Pfade, damit die Vitest-Tests ohne Nuxt laufen.
- Supabase-Projekt-Ref: `vsoqzbtusinpkeabygxg`. Kein Docker. Migrationen gehen mit `supabase db push` ins Remote-Projekt. SQL-Dateien laufen mit `supabase db query --linked -f <Datei>`, nicht über das MCP-Tool `execute_sql`.
- Der Arbeitszweig ist `mehrere-kurse`.

### Supabase-CLI aufrufen

Die CLI liest `.env` nicht selbst. Vor jedem CLI-Befehl, der das Remote-Projekt anspricht, in derselben PowerShell-Zeile die Variablen laden:

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase migration list
```

Die Werte von `SUPABASE_ACCESS_TOKEN` und `SUPABASE_DB_PASSWORD` werden nie ausgegeben.

### Entwicklungsserver

Auf Port 3000 läuft möglicherweise der Entwicklungsserver des Projektinhabers. Antwortet `http://localhost:3000`, wird dieser Server für die curl-Prüfungen benutzt und nicht beendet; `yarn build` entfällt dann, weil ein Build das Verzeichnis `.nuxt` des laufenden Servers überschreibt. Antwortet der Port nicht, startet der Ausführende `yarn dev` selbst im Hintergrund, beendet ihn nach den Prüfungen wieder und führt zusätzlich `yarn build` aus.

## Review Focus

1. Eine veröffentlichte Lektion in einem unveröffentlichten Kurs: Sie ist weder in Listen noch über ihre Adresse erreichbar (404). Prüfung in Task 2 (RLS) und Task 3 (Route).
2. Zwei Kurse mit Lektionen desselben Adressteils (zum Beispiel beide mit `projekt-anlegen`): Jede Adresse zeigt die Lektion ihres eigenen Kurses. Prüfung in Task 3.
3. Ein Kurs ohne Lektionen: Karte und Kursseite zeigen „0 Lektionen“ und 0 %, ohne Fehler und ohne „Kurs starten“. Test in Task 1, Prüfung in Task 3.
4. Abgeschlossene Lektionen aus einem anderen Kurs: Sie zählen nicht in Fortschritt und „Kurs weitermachen“ dieses Kurses. Test in Task 1.
5. Alte Adressen `/lektionen` und `/kurs/<slug>`: Sie liefern die 404-Seite mit Link zur Übersicht, keinen Serverfehler. Prüfung in Task 3.

## Dateiübersicht

| Datei | Aufgabe |
|---|---|
| `app/utils/courses.js` | Lektionen nach Kurs gruppieren, Kursübersicht berechnen |
| `tests/unit/courses.test.js` | Tests dafür |
| `supabase/migrations/*_multi_course.sql` | `courses`, `lessons.course_id`, `course_state`, RLS |
| `supabase/tests/rls.sql` | Prüfung der Zugriffsregeln (ersetzt) |
| `supabase/seeds/sample_courses.sql` | Beispielkurse (ersetzt `sample_lessons.sql`) |
| `app/composables/useCourses.js` | Kurse laden, Kurs per Adressteil auflösen |
| `app/composables/useLessons.js` | Alle Lektionslisten, eine Lektion per Kurs und Adressteil (geändert) |
| `app/composables/useCourseState.js` | Zuletzt geöffnete Lektion je Kurs (ersetzt `useProfile.js`) |
| `app/components/CourseCard.vue` | Kurskarte |
| `app/components/LessonList.vue`, `ResumeButton.vue` | Kurs im Pfad (geändert) |
| `app/pages/index.vue`, `app/pages/kurse/index.vue`, `app/pages/kurse/[kurs]/index.vue`, `app/pages/kurse/[kurs]/[lektion].vue`, `app/pages/profil.vue` | Seiten |
| `app/components/AppHeader.vue`, `app/pages/login.vue`, `app/pages/confirm.vue` | Menü und Ziele nach der Anmeldung |

---

### Task 1: Kurslogik

**Files:**
- Create: `app/utils/courses.js`
- Test: `tests/unit/courses.test.js`

**Interfaces:**
- Consumes: `countCompleted(lessons, completedIds)` und `percentComplete(lessons, completedIds)` aus `app/utils/progress.js`
- Produces:
  - `groupLessonsByCourse(lessons: Lesson[]): Record<number, Lesson[]>` (Reihenfolge je Kurs wie in der Eingabe)
  - `courseOverview(courses: Course[], lessons: Lesson[], completedIds: Set<number>): { course, lessons, done, total, percent }[]` (Reihenfolge wie `courses`)
  - `Lesson` hat mindestens `id`, `course_id`; `Course` hat mindestens `id`.

- [ ] **Step 1: Tests schreiben**

`tests/unit/courses.test.js`:

```js
import { describe, expect, it } from 'vitest'
import { courseOverview, groupLessonsByCourse } from '../../app/utils/courses.js'

const courses = [
  { id: 1, slug: 'erste-schritte' },
  { id: 2, slug: 'todo-app' },
  { id: 3, slug: 'leer' }
]

const lessons = [
  { id: 10, course_id: 1, slug: 'a' },
  { id: 11, course_id: 1, slug: 'b' },
  { id: 20, course_id: 2, slug: 'a' },
  { id: 21, course_id: 2, slug: 'b' },
  { id: 22, course_id: 2, slug: 'c' }
]

describe('groupLessonsByCourse', () => {
  it('ordnet jede Lektion ihrem Kurs zu', () => {
    const groups = groupLessonsByCourse(lessons)
    expect(groups[1].map(l => l.id)).toEqual([10, 11])
    expect(groups[2].map(l => l.id)).toEqual([20, 21, 22])
  })

  it('behält die Reihenfolge der Eingabe je Kurs, auch wenn die Kurse gemischt kommen', () => {
    const mixed = [lessons[2], lessons[0], lessons[3], lessons[1]]
    expect(groupLessonsByCourse(mixed)[2].map(l => l.id)).toEqual([20, 21])
    expect(groupLessonsByCourse(mixed)[1].map(l => l.id)).toEqual([10, 11])
  })

  it('liefert für eine leere Liste ein leeres Objekt', () => {
    expect(groupLessonsByCourse([])).toEqual({})
  })
})

describe('courseOverview', () => {
  it('liefert je Kurs seine Lektionen und den Fortschritt in Kursreihenfolge', () => {
    const overview = courseOverview(courses, lessons, new Set([10, 20, 21]))
    expect(overview.map(o => o.course.id)).toEqual([1, 2, 3])
    expect(overview[0]).toMatchObject({ done: 1, total: 2, percent: 50 })
    expect(overview[1]).toMatchObject({ done: 2, total: 3, percent: 66 })
  })

  it('zählt erledigte Lektionen anderer Kurse nicht mit', () => {
    const overview = courseOverview(courses, lessons, new Set([20, 21, 22]))
    expect(overview[0]).toMatchObject({ done: 0, total: 2, percent: 0 })
    expect(overview[1]).toMatchObject({ done: 3, total: 3, percent: 100 })
  })

  it('zeigt einen Kurs ohne Lektionen mit 0 von 0 und 0 Prozent', () => {
    const overview = courseOverview(courses, lessons, new Set([10]))
    expect(overview[2]).toMatchObject({ lessons: [], done: 0, total: 0, percent: 0 })
  })

  it('lässt Lektionen ohne passenden Kurs weg', () => {
    const orphan = [...lessons, { id: 99, course_id: 42, slug: 'x' }]
    const overview = courseOverview(courses, orphan, new Set([99]))
    expect(overview.flatMap(o => o.lessons.map(l => l.id))).not.toContain(99)
  })

  it('liefert für keine Kurse eine leere Liste', () => {
    expect(courseOverview([], lessons, new Set())).toEqual([])
  })
})
```

- [ ] **Step 2: Tests laufen lassen und Fehlschlag prüfen**

Run: `yarn test tests/unit/courses.test.js`
Expected: FAIL, `app/utils/courses.js` wird nicht gefunden.

- [ ] **Step 3: `courses.js` schreiben**

`app/utils/courses.js`:

```js
import { countCompleted, percentComplete } from './progress.js'

export function groupLessonsByCourse(lessons) {
  const groups = {}
  for (const lesson of lessons) {
    (groups[lesson.course_id] ??= []).push(lesson)
  }
  return groups
}

export function courseOverview(courses, lessons, completedIds) {
  const groups = groupLessonsByCourse(lessons)

  return courses.map((course) => {
    const courseLessons = groups[course.id] ?? []
    const { done, total } = countCompleted(courseLessons, completedIds)
    return { course, lessons: courseLessons, done, total, percent: percentComplete(courseLessons, completedIds) }
  })
}
```

- [ ] **Step 4: Tests laufen lassen**

Run: `yarn test`
Expected: PASS, 4 Dateien, 41 Tests.

- [ ] **Step 5: Commit**

```powershell
git add app/utils/courses.js tests/unit/courses.test.js
git commit -m "Add course grouping and overview logic with tests"
```

---

### Task 2: Datenbank auf mehrere Kurse umstellen

**Files:**
- Modify: `supabase/tests/rls.sql` (ersetzen)
- Create: `supabase/migrations/<Zeitstempel>_multi_course.sql` (über die CLI erzeugt)
- Create: `supabase/seeds/sample_courses.sql`
- Delete: `supabase/seeds/sample_lessons.sql`

**Interfaces:**
- Produces:
  - Tabelle `public.courses(id, slug, title, summary, position, recommended_course_id, published, created_at, updated_at)`
  - `public.lessons` mit `course_id`; eindeutig sind `(course_id, slug)` und `(course_id, position)`
  - Tabelle `public.course_state(user_id, course_id, last_lesson_id, updated_at)` mit Primärschlüssel `(user_id, course_id)`
  - `public.profiles` existiert nicht mehr
  - Beispielkurse `erste-schritte` (2 Lektionen), `todo-app` (4 sichtbare Lektionen, 1 unveröffentlichte), `leerer-kurs` (0 Lektionen), `entwurfskurs` (unveröffentlicht, 1 veröffentlichte Lektion)

- [ ] **Step 1: RLS-Prüfung ersetzen**

`supabase/tests/rls.sql`:

```sql
-- Prüft die Zugriffsregeln. Alles läuft in einer Transaktion und wird zurückgerollt.
-- Erfolg: Die letzte Abfrage liefert 'rls ok'. Jede verletzte Regel bricht mit einer Meldung ab.
begin;

do $$
declare
  user_a uuid := gen_random_uuid();
  user_b uuid := gen_random_uuid();
  open_course bigint;
  draft_course bigint;
  draft_id bigint;
  public_id bigint;
  hidden_id bigint;
  n integer;
begin
  insert into auth.users (id, instance_id, aud, role, email) values
    (user_a, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-a@example.test'),
    (user_b, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-b@example.test');

  insert into public.courses (slug, title, summary, position, published) values
    ('rls-test-open', 'Offen', 'x', 900001, true),
    ('rls-test-draft', 'Entwurf', 'x', 900002, false);
  select id into open_course from public.courses where slug = 'rls-test-open';
  select id into draft_course from public.courses where slug = 'rls-test-draft';

  insert into public.lessons (course_id, slug, title, summary, position, section, content, published) values
    (open_course, 'rls-test-draft', 'Entwurf', 'x', 1, 'start', 'x', false),
    (open_course, 'rls-test-public', 'Öffentlich', 'x', 2, 'start', 'x', true),
    -- Derselbe Adressteil in einem zweiten Kurs muss erlaubt sein.
    (draft_course, 'rls-test-public', 'Versteckt', 'x', 1, 'start', 'x', true);
  select id into draft_id from public.lessons where course_id = open_course and slug = 'rls-test-draft';
  select id into public_id from public.lessons where course_id = open_course and slug = 'rls-test-public';
  select id into hidden_id from public.lessons where course_id = draft_course and slug = 'rls-test-public';

  insert into public.lesson_progress (user_id, lesson_id) values (user_b, public_id);
  insert into public.course_state (user_id, course_id, last_lesson_id) values (user_b, open_course, public_id);

  -- Unangemeldet
  perform set_config('request.jwt.claims', '{"role":"anon"}', true);
  set local role anon;

  select count(*) into n from public.courses where slug = 'rls-test-draft';
  assert n = 0, 'anon sieht einen unveröffentlichten Kurs';
  select count(*) into n from public.courses where slug = 'rls-test-open';
  assert n = 1, 'anon sieht einen veröffentlichten Kurs nicht';

  select count(*) into n from public.lessons where id = draft_id;
  assert n = 0, 'anon sieht eine unveröffentlichte Lektion';
  select count(*) into n from public.lessons where id = public_id;
  assert n = 1, 'anon sieht eine veröffentlichte Lektion nicht';
  select count(*) into n from public.lessons where id = hidden_id;
  assert n = 0, 'anon sieht eine Lektion eines unveröffentlichten Kurses';

  begin
    update public.courses set title = 'geändert' where slug = 'rls-test-open';
    get diagnostics n = row_count;
    assert n = 0, 'anon konnte einen Kurs ändern';
  exception when insufficient_privilege then null;
  end;

  begin
    update public.lessons set title = 'geändert' where id = public_id;
    get diagnostics n = row_count;
    assert n = 0, 'anon konnte eine Lektion ändern';
  exception when insufficient_privilege then null;
  end;

  begin
    select count(*) into n from public.lesson_progress;
    assert n = 0, 'anon sieht Fortschritt';
  exception when insufficient_privilege then null;
  end;

  begin
    select count(*) into n from public.course_state;
    assert n = 0, 'anon sieht Kursstände';
  exception when insufficient_privilege then null;
  end;

  -- Angemeldet als Nutzer A
  perform set_config('request.jwt.claims', json_build_object('sub', user_a, 'role', 'authenticated')::text, true);
  set local role authenticated;

  select count(*) into n from public.courses where slug = 'rls-test-draft';
  assert n = 0, 'Nutzer sieht einen unveröffentlichten Kurs';
  select count(*) into n from public.lessons where id in (draft_id, hidden_id);
  assert n = 0, 'Nutzer sieht eine unveröffentlichte Lektion oder eine Lektion eines unveröffentlichten Kurses';

  select count(*) into n from public.lesson_progress;
  assert n = 0, 'A sieht fremden Fortschritt';
  select count(*) into n from public.course_state;
  assert n = 0, 'A sieht einen fremden Kursstand';

  begin
    insert into public.lesson_progress (user_id, lesson_id) values (user_b, draft_id);
    assert false, 'A konnte Fortschritt für B anlegen';
  exception when insufficient_privilege then null;
  end;

  delete from public.lesson_progress where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte Fortschritt von B löschen';

  update public.course_state set last_lesson_id = null where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte den Kursstand von B ändern';

  begin
    insert into public.course_state (user_id, course_id, last_lesson_id) values (gen_random_uuid(), open_course, public_id);
    assert false, 'A konnte einen fremden Kursstand anlegen';
  exception when insufficient_privilege then null;
  end;

  insert into public.lesson_progress (user_id, lesson_id) values (user_a, public_id);
  select count(*) into n from public.lesson_progress;
  assert n = 1, 'A sieht den eigenen Fortschritt nicht';

  insert into public.course_state (user_id, course_id, last_lesson_id) values (user_a, open_course, public_id);
  update public.course_state set last_lesson_id = null where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte den eigenen Kursstand nicht ändern';

  delete from public.lesson_progress where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte den eigenen Fortschritt nicht löschen';

  reset role;
end $$;

rollback;

select 'rls ok' as result;
```

- [ ] **Step 2: Prüfung ausführen und Fehlschlag sehen**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db query --linked -f supabase/tests/rls.sql
```

Expected: Fehler `relation "public.courses" does not exist`.

- [ ] **Step 3: Migrationsdatei erzeugen**

```powershell
yarn -s supabase migration new multi_course
```

Expected: Meldung mit dem Pfad `supabase/migrations/<Zeitstempel>_multi_course.sql`.

- [ ] **Step 4: Schema in die Migrationsdatei schreiben**

```sql
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
```

- [ ] **Step 5: Migration einspielen**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db push
```

Expected: Die Migration `multi_course` wird als angewendet gemeldet. Falls die CLI eine Bestätigung verlangt, den Befehl mit `--yes` wiederholen.

- [ ] **Step 6: RLS-Prüfung erneut ausführen**

Denselben Befehl wie in Step 2 ausführen.
Expected: Ergebniszeile `rls ok`.

Danach prüfen, dass nichts zurückgeblieben ist:

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db query --linked "select (select count(*) from public.courses where slug like 'rls-test-%') as courses, (select count(*) from auth.users where email like 'rls-%@example.test') as users"
```

Expected: `courses = 0`, `users = 0`.

- [ ] **Step 7: Sicherheitshinweise prüfen**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db advisors --linked
```

Expected: Keine Sicherheitshinweise zu `courses`, `lessons`, `lesson_progress` oder `course_state`. Jeden Hinweis zu diesen Tabellen beheben, bevor es weitergeht.

- [ ] **Step 8: Beispielkurse schreiben**

`supabase/seeds/sample_lessons.sql` löschen. `supabase/seeds/sample_courses.sql` anlegen:

````sql
-- Beispielkurse für die Entwicklung der Plattform.
-- Werden durch den echten Kursinhalt ersetzt.
insert into public.courses (slug, title, summary, position, published) values
  ('erste-schritte', 'Erste Schritte', 'Richte deinen Rechner ein und lerne, wie die Kurse funktionieren.', 1, true),
  ('todo-app', 'Todo-App', 'Bau Schritt für Schritt deine erste eigene Web-App.', 2, true),
  ('leerer-kurs', 'Bald verfügbar', 'Dieser Kurs hat noch keine Lektionen.', 3, true),
  ('entwurfskurs', 'Entwurfskurs', 'Dieser Kurs ist nicht veröffentlicht.', 4, false)
on conflict (slug) do nothing;

update public.courses
set recommended_course_id = (select id from public.courses where slug = 'erste-schritte')
where slug = 'todo-app';

insert into public.lessons (course_id, slug, title, summary, position, section, content, solution, published) values
(
  (select id from public.courses where slug = 'erste-schritte'),
  'willkommen', 'Willkommen', 'Wie die Kurse funktionieren.', 1, 'start',
  $md$
## Was dich erwartet

Hier lernst du Programmieren, indem du etwas **baust**. Du brauchst keine Vorkenntnisse.

- Du arbeitest auf deinem eigenen Rechner.
- Jede Lektion endet mit einer Aufgabe.

Mehr über Nuxt findest du in der [Dokumentation](https://nuxt.com).
$md$,
  null, true
),
(
  (select id from public.courses where slug = 'erste-schritte'),
  'werkzeuge-einrichten', 'Werkzeuge einrichten', 'Node.js und VS Code installieren.', 2, 'start',
  $md$
## Node.js

Prüfe im Terminal, ob Node.js installiert ist:

```bash
node --version
```
$md$,
  null, true
),
(
  (select id from public.courses where slug = 'todo-app'),
  'willkommen', 'Was wir bauen', 'Die fertige App und der Weg dorthin.', 1, 'start',
  $md$
## Die Todo-App

Am Ende dieses Kurses hast du eine eigene Aufgabenliste gebaut.
$md$,
  null, true
),
(
  (select id from public.courses where slug = 'todo-app'),
  'die-erste-seite', 'Die erste Seite', 'Wir schreiben das erste HTML in app.vue.', 2, 'html',
  $md$
## Das Template

Öffne die Datei `app/app.vue` und ersetze den Inhalt:

```vue [app/app.vue]
<template>
  <h1>Meine Aufgaben</h1>
</template>
```

### Deine Aufgabe

Füge unter der Überschrift einen Absatz mit einem kurzen Text ein.
$md$,
  $md$
```vue [app/app.vue]
<template>
  <h1>Meine Aufgaben</h1>
  <p>Hier entsteht meine erste App.</p>
</template>
```
$md$,
  true
),
(
  (select id from public.courses where slug = 'todo-app'),
  'tailwind-einrichten', 'Tailwind einrichten', 'Wir installieren Tailwind und setzen die ersten Klassen.', 3, 'css',
  $md$
## Installation

```bash
npm install tailwindcss @tailwindcss/vite
```
$md$,
  null, true
),
(
  (select id from public.courses where slug = 'todo-app'),
  'daten-anzeigen', 'Daten anzeigen', 'Wir zeigen eine Liste aus JavaScript an.', 4, 'js',
  $md$
## Eine Liste im Script

```vue [app/app.vue]
<script setup>
const tasks = ref(['Einkaufen', 'Lernen'])
</script>
```
$md$,
  null, true
),
(
  (select id from public.courses where slug = 'todo-app'),
  'entwurf', 'Entwurf', 'Diese Lektion ist nicht veröffentlicht.', 5, 'js',
  $md$
## Nicht sichtbar

Dieser Text darf auf der Seite nicht erscheinen.
$md$,
  null, false
),
(
  (select id from public.courses where slug = 'entwurfskurs'),
  'versteckt', 'Versteckt', 'Veröffentlichte Lektion in einem unveröffentlichten Kurs.', 1, 'start',
  $md$
## Nicht sichtbar

Dieser Text darf auf der Seite nicht erscheinen.
$md$,
  null, true
)
on conflict (course_id, slug) do nothing;
````

- [ ] **Step 9: Beispielkurse einspielen und prüfen**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db query --linked -f supabase/seeds/sample_courses.sql; yarn -s supabase db query --linked "select c.slug as course, c.published as course_published, count(l.id) as lessons, count(l.id) filter (where l.published) as published_lessons from public.courses c left join public.lessons l on l.course_id = c.id group by c.slug, c.published, c.position order by c.position"
```

Expected: vier Zeilen: `erste-schritte` (2 / 2), `todo-app` (5 / 4), `leerer-kurs` (0 / 0), `entwurfskurs` (unveröffentlicht, 1 / 1).

- [ ] **Step 10: Commit**

```powershell
git add supabase/migrations supabase/tests supabase/seeds
git commit -m "Restructure schema for multiple courses with per-course state"
```

---

### Task 3: Seiten und Bausteine auf mehrere Kurse umstellen

**Files:**
- Create: `app/composables/useCourses.js`, `app/composables/useCourseState.js`, `app/components/CourseCard.vue`
- Create: `app/pages/kurse/index.vue`, `app/pages/kurse/[kurs]/index.vue`, `app/pages/kurse/[kurs]/[lektion].vue`
- Modify: `app/composables/useLessons.js`, `app/components/LessonList.vue`, `app/components/ResumeButton.vue`, `app/components/AppHeader.vue`, `app/pages/index.vue`, `app/pages/profil.vue`, `app/pages/login.vue`, `app/pages/confirm.vue`
- Delete: `app/composables/useProfile.js`, `app/pages/lektionen.vue`, `app/pages/kurs/[slug].vue`

**Interfaces:**
- Consumes: `courseOverview`, `groupLessonsByCourse` aus Task 1; `countCompleted`, `percentComplete`, `resumeTarget`, `groupBySection` (vorhanden); Tabellen aus Task 2; `useProgress()` (unverändert: `{ completedIds, completedAt, complete, uncomplete }`); Komponenten `ProgressBar`, `SectionTag`, `LessonContent`, `LessonSolution`, `CompleteButton`, `PasswordForm` (unverändert); `useLogout()`
- Produces:
  - `useCourses()`: Rückgabe von `useAsyncData`; `data` ist `Course[]` mit `id, slug, title, summary, position, recommended_course_id`, Standard `[]`
  - `useCourseBySlug(slug)`: asynchron; liefert `{ course: ComputedRef<Course>, courses: Ref<Course[]> }`; wirft 404, wenn es den Kurs nicht gibt, und 503 bei Ladefehler
  - `useLessons()`: `data` ist die Liste aller sichtbaren Lektionen aller Kurse mit `id, course_id, slug, title, summary, position, section`, sortiert nach Kurs und Position
  - `useLesson(courseId, slug)`: eine Lektion mit `content`, `solution`; Fehler mit `statusCode` 404 oder 503
  - `useCourseState()`: `{ lastLessonByCourse: ComputedRef<Record<number, number | null>>, saveLastLesson(courseId, lessonId): Promise<void> }`
  - `<CourseCard :course :total :done :percent :show-progress level="h3">`
  - `<LessonList course-slug="todo-app" :lessons …>` (neuer Pflicht-Prop `courseSlug`)
  - `<ResumeButton :course :lessons>` (`lessons` sind die Lektionen dieses Kurses)

- [ ] **Step 1: `useCourses` schreiben**

`app/composables/useCourses.js`:

```js
export function useCourses() {
  const client = useSupabaseClient()

  return useAsyncData('courses', async () => {
    const { data, error } = await client
      .from('courses')
      .select('id, slug, title, summary, position, recommended_course_id')
      .order('position')
    if (error) {
      throw createError({ statusCode: 503, statusMessage: 'Die Kurse konnten nicht geladen werden.' })
    }
    return data
  }, { default: () => [] })
}

// Löst den Kurs aus der Adresse auf. Unbekannte und unveröffentlichte Kurse enden auf der 404-Seite.
export async function useCourseBySlug(slug) {
  const { data: courses, error } = await useCourses()
  if (error.value) {
    throw createError({ statusCode: 503, statusMessage: 'Die Kurse konnten nicht geladen werden.', fatal: true })
  }

  const course = computed(() => courses.value.find(item => item.slug === slug))
  if (!course.value) {
    throw createError({ statusCode: 404, statusMessage: 'Diesen Kurs gibt es nicht.', fatal: true })
  }

  return { course, courses }
}
```

- [ ] **Step 2: `useLessons` ersetzen**

`app/composables/useLessons.js`:

```js
const LIST_COLUMNS = 'id, course_id, slug, title, summary, position, section'

// Lädt die Lektionslisten aller Kurse auf einmal; die Seiten filtern nach Kurs.
export function useLessons() {
  const client = useSupabaseClient()

  return useAsyncData('lessons', async () => {
    const { data, error } = await client
      .from('lessons')
      .select(LIST_COLUMNS)
      .order('course_id')
      .order('position')
    if (error) {
      throw createError({ statusCode: 503, statusMessage: 'Die Lektionen konnten nicht geladen werden.' })
    }
    return data
  }, { default: () => [] })
}

export function useLesson(courseId, slug) {
  const client = useSupabaseClient()

  return useAsyncData(`lesson-${courseId}-${slug}`, async () => {
    const { data, error } = await client
      .from('lessons')
      .select(`${LIST_COLUMNS}, content, solution`)
      .eq('course_id', courseId)
      .eq('slug', slug)
      .maybeSingle()
    if (error) {
      throw createError({ statusCode: 503, statusMessage: 'Die Lektion konnte nicht geladen werden.' })
    }
    if (!data) {
      throw createError({ statusCode: 404, statusMessage: 'Diese Lektion gibt es nicht.' })
    }
    return data
  })
}
```

- [ ] **Step 3: `useCourseState` schreiben, `useProfile` löschen**

`app/composables/useProfile.js` löschen. `app/composables/useCourseState.js` anlegen:

```js
export function useCourseState() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  const state = useAsyncData('course-state', async () => {
    if (!user.value) return []
    const { data, error } = await client.from('course_state').select('course_id, last_lesson_id')
    return error ? [] : data
  }, { watch: [() => user.value?.sub], default: () => [] })

  const rows = state.data
  const lastLessonByCourse = computed(() => Object.fromEntries(rows.value.map(row => [row.course_id, row.last_lesson_id])))

  async function saveLastLesson(courseId, lessonId) {
    const userId = user.value?.sub
    if (!userId) return
    // Erst den laufenden Abruf abwarten, sonst überschreibt sein Ergebnis den neuen Wert.
    await state
    const previous = rows.value
    rows.value = [...previous.filter(row => row.course_id !== courseId), { course_id: courseId, last_lesson_id: lessonId }]
    const { error } = await client
      .from('course_state')
      .upsert({ user_id: userId, course_id: courseId, last_lesson_id: lessonId, updated_at: new Date().toISOString() })
    if (error) rows.value = previous
  }

  return { lastLessonByCourse, saveLastLesson }
}
```

- [ ] **Step 4: `LessonList` anpassen**

In `app/components/LessonList.vue` zwei Änderungen:

Im `defineProps`-Objekt als erste Zeile ergänzen:

```js
  courseSlug: { type: String, required: true },
```

Im Template das Ziel des Links ändern von

```vue
            :to="`/kurs/${lesson.slug}`"
```

zu

```vue
            :to="`/kurse/${courseSlug}/${lesson.slug}`"
```

- [ ] **Step 5: `ResumeButton` ersetzen**

`app/components/ResumeButton.vue`:

```vue
<script setup>
const props = defineProps({
  course: { type: Object, required: true },
  lessons: { type: Array, required: true }
})

const { completedIds } = useProgress()
const { lastLessonByCourse } = useCourseState()

const target = computed(() => resumeTarget(props.lessons, completedIds.value, lastLessonByCourse.value[props.course.id] ?? null))
</script>

<template>
  <NuxtLink v-if="target.state === 'start'" :to="`/kurse/${course.slug}/${target.lesson.slug}`" class="btn-primary">
    Kurs starten
  </NuxtLink>
  <NuxtLink v-else-if="target.state === 'continue'" :to="`/kurse/${course.slug}/${target.lesson.slug}`" class="btn-primary">
    Kurs weitermachen
  </NuxtLink>
  <p v-else-if="target.state === 'done'" class="text-sm">
    <span class="font-semibold text-ink">Kurs abgeschlossen.</span>
    <NuxtLink :to="`/kurse/${course.slug}/${target.lesson.slug}`" class="text-link ml-2">Zur letzten Lektion</NuxtLink>
  </p>
</template>
```

- [ ] **Step 6: `CourseCard` schreiben**

`app/components/CourseCard.vue`:

```vue
<script setup>
defineProps({
  course: { type: Object, required: true },
  total: { type: Number, required: true },
  done: { type: Number, default: 0 },
  percent: { type: Number, default: 0 },
  showProgress: { type: Boolean, default: false },
  level: { type: String, default: 'h3' }
})
</script>

<template>
  <NuxtLink
    :to="`/kurse/${course.slug}`"
    class="flex h-full flex-col rounded-xl border border-mist/60 bg-paper p-6 transition-colors hover:border-ink"
  >
    <component :is="level" class="text-2xl font-medium text-ink">{{ course.title }}</component>
    <p class="mt-2 flex-1">{{ course.summary }}</p>
    <p class="mt-6 text-sm text-pewter">{{ total }} {{ total === 1 ? 'Lektion' : 'Lektionen' }}</p>
    <ProgressBar v-if="showProgress" class="mt-4" :percent="percent" :label="`${done} von ${total} erledigt`" />
  </NuxtLink>
</template>
```

- [ ] **Step 7: Kursübersicht schreiben**

`app/pages/kurse/index.vue`:

```vue
<script setup>
const user = useSupabaseUser()
const { data: courses, error: coursesError } = await useCourses()
const { data: lessons, error: lessonsError } = await useLessons()
const { completedIds } = useProgress()

const overview = computed(() => courseOverview(courses.value, lessons.value, completedIds.value))
const failed = computed(() => Boolean(coursesError.value || lessonsError.value))

useSeoMeta({
  title: 'Kurse',
  description: 'Alle Kurse im Überblick: Such dir ein Projekt aus und bau es Schritt für Schritt selbst.'
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink sm:text-5xl sm:tracking-[-0.025em]">Kurse</h1>
      <p class="mt-4 max-w-[640px] text-xl">
        Such dir ein Projekt aus und bau es Schritt für Schritt selbst. Jeder Kurs steht für sich.
      </p>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <p v-if="failed" class="notice max-w-[640px] bg-paper" role="alert">
          Die Kurse konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="overview.length === 0">Die ersten Kurse erscheinen bald.</p>
        <ul v-else class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <li v-for="item in overview" :key="item.course.id">
            <CourseCard
              :course="item.course"
              :total="item.total"
              :done="item.done"
              :percent="item.percent"
              :show-progress="Boolean(user) && item.total > 0"
              level="h2"
            />
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>
```

- [ ] **Step 8: Kursseite schreiben**

`app/pages/kurse/[kurs]/index.vue`:

```vue
<script setup>
const route = useRoute()
const user = useSupabaseUser()

const { course, courses } = await useCourseBySlug(route.params.kurs)
const { data: allLessons, error } = await useLessons()
const { completedIds, completedAt } = useProgress()

const lessons = computed(() => allLessons.value.filter(lesson => lesson.course_id === course.value.id))
const percent = computed(() => percentComplete(lessons.value, completedIds.value))
const counts = computed(() => countCompleted(lessons.value, completedIds.value))

// Der Hinweis auf den empfohlenen Kurs entfällt, sobald dieser vollständig abgeschlossen ist.
const recommended = computed(() => {
  const candidate = courses.value.find(item => item.id === course.value.recommended_course_id)
  if (!candidate) return null
  const candidateLessons = allLessons.value.filter(lesson => lesson.course_id === candidate.id)
  const { done, total } = countCompleted(candidateLessons, completedIds.value)
  return total > 0 && done === total ? null : candidate
})

useSeoMeta({
  title: () => course.value.title,
  description: () => course.value.summary
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <NuxtLink to="/kurse" class="btn-ghost">← Alle Kurse</NuxtLink>
      <h1 class="mt-6 text-4xl font-medium tracking-[-0.02em] text-ink sm:text-5xl sm:tracking-[-0.025em]">
        {{ course.title }}
      </h1>
      <p class="mt-4 max-w-[640px] text-xl">{{ course.summary }}</p>

      <p v-if="recommended" class="notice mt-8 max-w-[640px]">
        Neu hier? Mach zuerst den Kurs
        <NuxtLink :to="`/kurse/${recommended.slug}`" class="text-link">„{{ recommended.title }}“</NuxtLink>.
        Dort richtest du alles ein, was du für diesen Kurs brauchst.
      </p>

      <template v-if="user && lessons.length > 0">
        <ProgressBar class="mt-10 max-w-md" :percent="percent" label="Dein Fortschritt" />
        <p class="mt-2 text-sm">{{ counts.done }} von {{ counts.total }} Lektionen erledigt</p>
      </template>

      <div class="mt-8 flex flex-wrap items-center gap-6">
        <ResumeButton :course="course" :lessons="lessons" />
        <NuxtLink v-if="!user" to="/registrieren" class="btn-ghost">
          Konto erstellen und Fortschritt speichern
        </NuxtLink>
      </div>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-2xl font-medium text-ink">Lektionen</h2>
        <p v-if="error" class="notice mt-8 max-w-[640px] bg-paper" role="alert">
          Die Lektionen konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="lessons.length === 0" class="mt-8">Die Lektionen dieses Kurses erscheinen bald.</p>
        <LessonList
          v-else
          class="mt-8 max-w-3xl"
          :course-slug="course.slug"
          :lessons="lessons"
          :completed-ids="completedIds"
          :completed-at="completedAt"
          :show-counts="Boolean(user)"
          show-summary
        />
      </div>
    </section>
  </div>
</template>
```

- [ ] **Step 9: Lektionsseite schreiben, alte Seiten löschen**

`app/pages/kurs/[slug].vue` und `app/pages/lektionen.vue` löschen (der Ordner `app/pages/kurs` entfällt damit). `app/pages/kurse/[kurs]/[lektion].vue` anlegen:

```vue
<script setup>
const route = useRoute()
const user = useSupabaseUser()

const { course } = await useCourseBySlug(route.params.kurs)

const { data: lesson, error } = await useLesson(course.value.id, route.params.lektion)
if (error.value) {
  throw createError({
    statusCode: error.value.statusCode ?? 500,
    statusMessage: error.value.statusMessage ?? 'Die Lektion konnte nicht geladen werden.',
    fatal: true
  })
}

const { data: allLessons } = await useLessons()
const { completedIds } = useProgress()
const { saveLastLesson } = useCourseState()

const lessons = computed(() => allLessons.value.filter(item => item.course_id === course.value.id))
const index = computed(() => lessons.value.findIndex(item => item.id === lesson.value.id))
const previous = computed(() => (index.value > 0 ? lessons.value[index.value - 1] : null))
const next = computed(() => (index.value >= 0 && index.value < lessons.value.length - 1 ? lessons.value[index.value + 1] : null))

// Merkt sich die zuletzt geöffnete Lektion des Kurses, auch wenn man sich erst auf dieser Seite anmeldet.
watch(() => user.value?.sub, (userId) => {
  if (userId && import.meta.client) saveLastLesson(course.value.id, lesson.value.id)
}, { immediate: true })

useSeoMeta({
  title: () => `${lesson.value.title} · ${course.value.title}`,
  description: () => lesson.value.summary
})
</script>

<template>
  <div class="mx-auto grid max-w-[1200px] gap-8 px-4 py-8 sm:px-6 lg:grid-cols-[280px_minmax(0,1fr)] lg:gap-12 lg:py-12">
    <aside>
      <details class="rounded-xl border border-mist/60 lg:hidden">
        <summary class="px-4 py-3 text-sm font-medium text-ink">{{ course.title }}: alle Lektionen</summary>
        <div class="border-t border-mist/60 p-4">
          <LessonList :course-slug="course.slug" :lessons="lessons" :completed-ids="completedIds" :current-slug="lesson.slug" />
        </div>
      </details>
      <nav class="sticky top-24 hidden max-h-[calc(100vh-8rem)] overflow-y-auto lg:block" aria-label="Lektionen">
        <NuxtLink :to="`/kurse/${course.slug}`" class="mb-4 block text-sm font-medium text-ink hover:underline">
          ← {{ course.title }}
        </NuxtLink>
        <LessonList :course-slug="course.slug" :lessons="lessons" :completed-ids="completedIds" :current-slug="lesson.slug" />
      </nav>
    </aside>

    <article class="min-w-0">
      <SectionTag :section="lesson.section" />
      <h1 class="mt-3 text-4xl font-medium leading-tight tracking-[-0.02em] text-ink sm:text-5xl sm:tracking-[-0.025em]">
        {{ lesson.title }}
      </h1>
      <p class="mt-4 max-w-[640px] text-xl">{{ lesson.summary }}</p>

      <LessonContent class="mt-10" :value="lesson.content" />
      <LessonSolution v-if="lesson.solution" :value="lesson.solution" />

      <CompleteButton class="mt-12" :lesson-id="lesson.id" />

      <nav class="mt-12 flex max-w-[640px] justify-between gap-4 border-t border-mist/60 pt-6 text-sm" aria-label="Blättern">
        <NuxtLink v-if="previous" :to="`/kurse/${course.slug}/${previous.slug}`" class="btn-ghost">← {{ previous.title }}</NuxtLink>
        <span v-else />
        <NuxtLink v-if="next" :to="`/kurse/${course.slug}/${next.slug}`" class="btn-ghost text-right">{{ next.title }} →</NuxtLink>
      </nav>
    </article>
  </div>
</template>
```

- [ ] **Step 10: Startseite ersetzen**

`app/pages/index.vue`:

```vue
<script setup>
const user = useSupabaseUser()
const { data: courses, error: coursesError } = await useCourses()
const { data: lessons, error: lessonsError } = await useLessons()
const { completedIds } = useProgress()

const overview = computed(() => courseOverview(courses.value, lessons.value, completedIds.value))
const failed = computed(() => Boolean(coursesError.value || lessonsError.value))

useSeoMeta({
  title: 'Programmieren lernen mit Nuxt',
  description: 'Kostenlose Schnupperkurse: Bau Schritt für Schritt deine erste eigene Web-App mit HTML, CSS und JavaScript.'
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h1 class="max-w-3xl text-5xl font-medium leading-none tracking-[-0.025em] text-ink sm:text-7xl sm:tracking-[-0.03em]">
        Lern programmieren, indem du etwas baust.
      </h1>
      <p class="mt-6 max-w-[640px] text-xl">
        In kostenlosen Kursen baust du auf deinem eigenen Rechner kleine Web-Apps mit Nuxt.
        Du brauchst keine Vorkenntnisse, nur etwas Neugier.
      </p>
      <div class="mt-8 flex flex-wrap items-center gap-6">
        <NuxtLink to="/kurse" class="btn-primary">Kurse ansehen</NuxtLink>
        <NuxtLink v-if="!user" to="/registrieren" class="btn-ghost">
          Konto erstellen und Fortschritt speichern
        </NuxtLink>
      </div>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-4xl font-medium tracking-[-0.02em] text-ink">Die Kurse</h2>
        <p v-if="failed" class="notice mt-8 max-w-[640px] bg-paper" role="alert">
          Die Kurse konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="overview.length === 0" class="mt-8">Die ersten Kurse erscheinen bald.</p>
        <ul v-else class="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <li v-for="item in overview" :key="item.course.id">
            <CourseCard
              :course="item.course"
              :total="item.total"
              :done="item.done"
              :percent="item.percent"
              :show-progress="Boolean(user) && item.total > 0"
            />
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>
```

- [ ] **Step 11: Profil ersetzen**

`app/pages/profil.vue`:

```vue
<script setup>
definePageMeta({ middleware: 'auth' })

const user = useSupabaseUser()
const logout = useLogout()
const { data: courses } = await useCourses()
const { data: lessons } = await useLessons()
const { completedIds } = useProgress()
const { lastLessonByCourse } = useCourseState()

// Begonnen ist ein Kurs, sobald eine seiner Lektionen erledigt oder geöffnet wurde.
const started = computed(() => courseOverview(courses.value, lessons.value, completedIds.value)
  .filter(item => item.done > 0 || lastLessonByCourse.value[item.course.id] != null))

useSeoMeta({ title: 'Profil' })
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <p class="text-sm font-medium text-pewter">Dein Profil</p>
      <h1 class="mt-2 break-words text-4xl font-medium tracking-[-0.02em] text-ink">{{ user?.email }}</h1>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-2xl font-medium text-ink">Deine Kurse</h2>
        <div v-if="started.length === 0" class="mt-8">
          <p class="max-w-[640px]">Du hast noch keinen Kurs begonnen.</p>
          <NuxtLink to="/kurse" class="btn-primary mt-6">Kurse ansehen</NuxtLink>
        </div>
        <ul v-else class="mt-8 grid gap-6 lg:grid-cols-2">
          <li v-for="item in started" :key="item.course.id" class="rounded-xl border border-mist/60 bg-paper p-6">
            <h3 class="text-xl font-medium text-ink">
              <NuxtLink :to="`/kurse/${item.course.slug}`" class="hover:underline">{{ item.course.title }}</NuxtLink>
            </h3>
            <ProgressBar class="mt-4" :percent="item.percent" :label="`${item.done} von ${item.total} Lektionen erledigt`" />
            <div class="mt-6">
              <ResumeButton :course="item.course" :lessons="item.lessons" />
            </div>
          </li>
        </ul>
      </div>
    </section>

    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h2 class="text-2xl font-medium text-ink">Passwort ändern</h2>
      <PasswordForm class="mt-8" />

      <h2 class="mt-16 text-2xl font-medium text-ink">Abmelden</h2>
      <button type="button" class="btn-secondary mt-6" @click="logout">Abmelden</button>
    </section>
  </div>
</template>
```

- [ ] **Step 12: Menü und Ziele nach der Anmeldung anpassen**

In `app/components/AppHeader.vue` den Menüpunkt ändern von

```vue
        <NuxtLink to="/lektionen" class="transition-colors hover:text-ember" active-class="text-ember">Lektionen</NuxtLink>
```

zu

```vue
        <NuxtLink to="/kurse" class="transition-colors hover:text-ember" active-class="text-ember">Kurse</NuxtLink>
```

In `app/pages/login.vue` das Standardziel `'/lektionen'` durch `'/kurse'` ersetzen. In `app/pages/confirm.vue` `navigateTo('/lektionen')` durch `navigateTo('/kurse')` ersetzen.

Danach darf es im Ordner `app/` keinen Verweis mehr auf `/lektionen`, `/kurs/` (mit Schrägstrich direkt nach `kurs`), `useProfile` oder `profiles` geben:

```powershell
Get-ChildItem app -Recurse -Include *.vue, *.js | Select-String -Pattern '/lektionen|/kurs/|useProfile|profiles' | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
```

Expected: keine Treffer.

- [ ] **Step 13: Prüfen**

Run: `yarn test`
Expected: PASS, 41 Tests.

Nach den Regeln im Abschnitt „Entwicklungsserver“ den laufenden Server benutzen oder einen eigenen starten. Dann die Statuscodes prüfen:

| Adresse | Erwartet |
|---|---|
| `/`, `/kurse`, `/kurse/erste-schritte`, `/kurse/todo-app`, `/kurse/leerer-kurs` | 200 |
| `/kurse/erste-schritte/willkommen`, `/kurse/todo-app/willkommen`, `/kurse/todo-app/die-erste-seite` | 200 |
| `/kurse/entwurfskurs`, `/kurse/entwurfskurs/versteckt`, `/kurse/todo-app/entwurf`, `/kurse/todo-app/gibt-es-nicht`, `/kurse/gibt-es-nicht` | 404 |
| `/lektionen`, `/kurs/willkommen` | 404 |
| `/profil` | 302 |
| `/login`, `/registrieren`, `/passwort-vergessen`, `/impressum` | 200 |

Im ausgelieferten HTML prüfen (Umlaute vermeiden oder die Ausgabe als UTF-8 lesen):

1. `/kurse` enthält `Erste Schritte`, `Todo-App` und `Bald verf`, aber nicht `Entwurfskurs`. Die Karte des leeren Kurses zeigt `0 Lektionen`.
2. `/kurse/todo-app` enthält den Hinweis auf `Erste Schritte` mit Link auf `/kurse/erste-schritte`, die Lektion `Die erste Seite` und den Link `/kurse/todo-app/die-erste-seite`; es enthält nicht `Diese Lektion ist nicht ver`.
3. `/kurse/leerer-kurs` enthält `erscheinen bald` und weder `Kurs starten` noch `Kurs weitermachen`.
4. `/kurse/erste-schritte/willkommen` enthält `Was dich erwartet`; `/kurse/todo-app/willkommen` enthält `Die Todo-App` und nicht `Was dich erwartet`. Das beweist, dass derselbe Adressteil in zwei Kursen getrennt aufgelöst wird.
5. `/kurse/todo-app/die-erste-seite` enthält `code-block`, `app/app.vue`, `Deine Aufgabe` und `Musterl`.
6. Die Kopfzeile enthält einen Link auf `/kurse` mit dem Text `Kurse`.

Wurde ein eigener Server gestartet: sein Log auf Vue- und Nuxt-Warnungen aus den geänderten Dateien prüfen, deren Ursache beheben, den Server beenden und `yarn build` ausführen (muss ohne Fehler enden).

- [ ] **Step 14: Commit**

```powershell
git add -A app
git commit -m "Restructure pages and components for multiple courses"
```
