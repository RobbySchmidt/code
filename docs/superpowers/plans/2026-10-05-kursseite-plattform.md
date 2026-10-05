# Kursseite – Plattform: Umsetzungsplan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Die Kursseite mit Lektionsanzeige aus Supabase, Konto, Fortschritt und Profil bauen, sodass sie mit Beispiel-Lektionen vollständig benutzbar ist.

**Architecture:** Nuxt 4 rendert serverseitig und liest Lektionen mit dem öffentlichen Schlüssel aus Supabase; RLS regelt jeden Zugriff. Drei Composables (`useLessons`, `useProgress`, `useProfile`) kapseln alle Datenbankzugriffe, reine Funktionen in `app/utils/` tragen die Logik und sind mit Vitest getestet. Markdown wird zur Laufzeit mit `@nuxtjs/mdc` gerendert.

**Tech Stack:** Nuxt 4, `@nuxtjs/supabase` 2.x, `@nuxtjs/mdc`, Tailwind 4, `@fontsource-variable/inter`, Vitest, Supabase CLI und Supabase-MCP.

**Spec:** `docs/superpowers/specs/2026-10-05-nuxt-kursseite-design.md`

**Abgrenzung:** Dieser Plan deckt die Plattform ab. Die 16 echten Lektionen (Todo-App nachbauen, Texte und Musterlösungen schreiben, einspielen) bekommen einen eigenen Plan. Bis dahin laufen Beispiel-Lektionen aus `supabase/seeds/sample_lessons.sql`.

## Global Constraints

- JavaScript mit `<script setup>`, kein TypeScript, in allen `.vue`- und `.js`-Dateien.
- Paketmanager ist yarn 1.x. Shell ist PowerShell unter Windows.
- Alle sichtbaren Texte sind deutsch und duzen.
- Genau eine Akzentfarbe: Ember `#ff5900`. Nur für die Hauptaktion je Bereich, den Fortschrittsbalken und Häkchen. Keine zweite Akzentfarbe, auch nicht für Fehler.
- Links im Fließtext: Ink mit Unterstreichung, nicht Ember.
- Keine Schatten für Karten. Abgrenzung über Paper auf Fog und 1px-Rahmen in Mist.
- Radien: `rounded-xl` (12px) für Buttons, Eingabefelder, Karten; `rounded-md` (6px) für Etiketten. Keine anderen Radien.
- Schrift: Inter, Gewichte 400, 500, 600. Laufweite −0,01em bis 24px, −0,02em bei 36px, −0,025em bei 48px, −0,03em bei 72px.
- Seite maximal 1200px breit, Fließtext maximal 640px, linksbündig.
- `supabase.redirect` bleibt `false`. Lektionen sind ohne Login lesbar.
- Supabase-Projekt-Ref: `vsoqzbtusinpkeabygxg`. Kein Docker; Migrationen gehen mit `supabase db push` direkt ins Remote-Projekt.
- `useSupabaseUser()` liefert JWT-Claims: Die Nutzer-ID steht in `user.value.sub`, die Adresse in `user.value.email`. Es gibt kein `user.value.id`.
- Dateien in `app/utils/` und `app/composables/` werden von Nuxt automatisch importiert. Tests importieren sie über relative Pfade.
- Der Arbeitszweig ist `kursseite`.

### Supabase-CLI aufrufen

Die CLI liest `.env` nicht selbst. Vor jedem CLI-Befehl in derselben PowerShell-Zeile die Variablen laden:

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase migration list
```

SQL gegen die Datenbank läuft über das MCP-Tool `mcp__supabase__execute_sql`.

## Review Focus

1. Abgeschlossene Lektionen, die nicht mehr in der Liste stehen (zurückgezogen oder gelöscht): Der Prozentwert bleibt höchstens 100 und zählt nur sichtbare Lektionen. Test in Task 1.
2. Zuletzt geöffnete Lektion existiert nicht mehr oder ist schon abgeschlossen: „Kurs weitermachen“ führt zur ersten offenen Lektion statt ins Leere. Test in Task 1.
3. Registrierung mit einer bereits registrierten Adresse: Supabase meldet dabei keinen Fehler. Die Seite sagt trotzdem, dass es das Konto schon gibt, statt eine Bestätigungsmail anzukündigen. Test in Task 2.
4. Bestätigungs- oder Reset-Link ist abgelaufen oder wird in einem anderen Browser geöffnet: Es erscheint eine Erklärung mit Link zum Login bzw. zu „Passwort vergessen“, keine dauerhafte Ladeanzeige. Prüfung in Task 5.
5. Doppelklick auf „Lektion abschließen“: Es entsteht kein Fehler und keine doppelte Zeile. Prüfung in Task 7.

## Dateiübersicht

| Datei | Aufgabe |
|---|---|
| `app/utils/sections.js` | Blöcke: Reihenfolge, Anzeigenamen, Gruppieren |
| `app/utils/progress.js` | Zählen, Prozentwert, Ziel von „Kurs weitermachen“ |
| `app/utils/authErrors.js` | Deutsche Meldungen für Supabase-Auth-Fehler |
| `tests/unit/*.test.js` | Vitest-Tests für die drei Utils |
| `supabase/migrations/*_course_schema.sql` | Tabellen, Trigger, Grants, RLS |
| `supabase/tests/rls.sql` | Prüfung der Zugriffsregeln |
| `supabase/seeds/sample_lessons.sql` | Beispiel-Lektionen |
| `app/assets/css/main.css` | Token, Basis- und Bausteinklassen, Lektionstypografie |
| `app/app.vue`, `app/layouts/default.vue`, `app/error.vue` | Rahmen und Fehlerseite |
| `app/components/AppHeader.vue`, `AppFooter.vue` | Kopf und Fuß |
| `app/components/AuthForm.vue`, `PasswordForm.vue` | Formulare |
| `app/middleware/auth.js` | Schutz für `/profil` |
| `app/composables/useLessons.js`, `useProgress.js`, `useProfile.js` | Datenzugriff |
| `app/components/SectionTag.vue`, `LessonList.vue`, `ProgressBar.vue`, `ResumeButton.vue` | Listen- und Fortschrittsbausteine |
| `app/components/LessonContent.vue`, `LessonSolution.vue`, `CompleteButton.vue`, `app/components/mdc/ProsePre.vue` | Lektionsbausteine |
| `app/pages/*.vue`, `app/pages/kurs/[slug].vue` | Seiten |

---

### Task 1: Testwerkzeug und Fortschrittslogik

**Files:**
- Modify: `package.json`
- Create: `app/utils/sections.js`, `app/utils/progress.js`
- Test: `tests/unit/sections.test.js`, `tests/unit/progress.test.js`

**Interfaces:**
- Produces:
  - `SECTIONS`: Array aus `{ key, label }` in Kursreihenfolge
  - `sectionLabel(key: string): string`
  - `groupBySection(lessons: Lesson[]): { key, label, lessons }[]`
  - `countCompleted(lessons: Lesson[], completedIds: Set<number>): { done: number, total: number }`
  - `percentComplete(lessons: Lesson[], completedIds: Set<number>): number` (0–100, abgerundet)
  - `resumeTarget(lessons: Lesson[], completedIds: Set<number>, lastLessonId: number | null): { state: 'empty' | 'start' | 'continue' | 'done', lesson: Lesson | null }`
  - `Lesson` ist ein Objekt mit mindestens `id` (Zahl), `slug`, `section`; die Liste ist nach `position` sortiert.

- [ ] **Step 1: Vitest installieren und Skript anlegen**

```powershell
yarn add -D vitest
```

In `package.json` unter `scripts` ergänzen:

```json
"test": "vitest run"
```

- [ ] **Step 2: Tests für `sections.js` schreiben**

`tests/unit/sections.test.js`:

```js
import { describe, expect, it } from 'vitest'
import { SECTIONS, groupBySection, sectionLabel } from '../../app/utils/sections.js'

const lesson = (id, section) => ({ id, slug: `l${id}`, section })

describe('sectionLabel', () => {
  it('liefert den Anzeigenamen eines Blocks', () => {
    expect(sectionLabel('js')).toBe('JavaScript')
  })

  it('gibt bei unbekanntem Block den Schlüssel zurück', () => {
    expect(sectionLabel('bonus')).toBe('bonus')
  })
})

describe('groupBySection', () => {
  it('gruppiert in Kursreihenfolge, unabhängig von der Eingabereihenfolge', () => {
    const groups = groupBySection([lesson(1, 'js'), lesson(2, 'start'), lesson(3, 'html')])
    expect(groups.map(g => g.key)).toEqual(['start', 'html', 'js'])
  })

  it('lässt leere Blöcke weg', () => {
    const groups = groupBySection([lesson(1, 'css')])
    expect(groups).toHaveLength(1)
    expect(groups[0]).toMatchObject({ key: 'css', label: 'CSS' })
  })

  it('behält die Reihenfolge der Lektionen innerhalb eines Blocks', () => {
    const groups = groupBySection([lesson(1, 'js'), lesson(2, 'js')])
    expect(groups[0].lessons.map(l => l.id)).toEqual([1, 2])
  })

  it('hängt Lektionen mit unbekanntem Block ans Ende, statt sie zu verschlucken', () => {
    const groups = groupBySection([lesson(1, 'bonus'), lesson(2, 'start')])
    expect(groups.map(g => g.key)).toEqual(['start', 'bonus'])
  })

  it('liefert für eine leere Liste keine Gruppen', () => {
    expect(groupBySection([])).toEqual([])
  })
})

describe('SECTIONS', () => {
  it('enthält die fünf Blöcke der Spec', () => {
    expect(SECTIONS.map(s => s.key)).toEqual(['start', 'html', 'css', 'js', 'abschluss'])
  })
})
```

- [ ] **Step 3: Tests für `progress.js` schreiben**

`tests/unit/progress.test.js`:

```js
import { describe, expect, it } from 'vitest'
import { countCompleted, percentComplete, resumeTarget } from '../../app/utils/progress.js'

const lessons = [
  { id: 10, slug: 'a', section: 'start' },
  { id: 20, slug: 'b', section: 'html' },
  { id: 30, slug: 'c', section: 'js' }
]

describe('countCompleted', () => {
  it('zählt erledigte und alle Lektionen', () => {
    expect(countCompleted(lessons, new Set([10, 30]))).toEqual({ done: 2, total: 3 })
  })

  it('ignoriert erledigte Lektionen, die nicht in der Liste stehen', () => {
    expect(countCompleted(lessons, new Set([10, 999]))).toEqual({ done: 1, total: 3 })
  })
})

describe('percentComplete', () => {
  it('ist 0 bei leerer Liste', () => {
    expect(percentComplete([], new Set([10]))).toBe(0)
  })

  it('rundet ab, damit 100 erst bei allen Lektionen erscheint', () => {
    expect(percentComplete(lessons, new Set([10, 20]))).toBe(66)
  })

  it('ist 100, wenn alles erledigt ist', () => {
    expect(percentComplete(lessons, new Set([10, 20, 30]))).toBe(100)
  })

  it('übersteigt 100 nicht, wenn zurückgezogene Lektionen erledigt waren', () => {
    expect(percentComplete(lessons, new Set([10, 20, 30, 998, 999]))).toBe(100)
  })
})

describe('resumeTarget', () => {
  it('meldet eine leere Lektionsliste', () => {
    expect(resumeTarget([], new Set(), null)).toEqual({ state: 'empty', lesson: null })
  })

  it('startet bei der ersten Lektion, wenn noch nichts passiert ist', () => {
    expect(resumeTarget(lessons, new Set(), null)).toEqual({ state: 'start', lesson: lessons[0] })
  })

  it('führt zur zuletzt geöffneten Lektion, wenn sie offen ist', () => {
    expect(resumeTarget(lessons, new Set([10]), 30)).toEqual({ state: 'continue', lesson: lessons[2] })
  })

  it('führt zur ersten offenen Lektion, wenn die zuletzt geöffnete erledigt ist', () => {
    expect(resumeTarget(lessons, new Set([10, 20]), 20)).toEqual({ state: 'continue', lesson: lessons[2] })
  })

  it('führt zur ersten offenen Lektion, wenn die zuletzt geöffnete nicht mehr existiert', () => {
    expect(resumeTarget(lessons, new Set([10]), 999)).toEqual({ state: 'continue', lesson: lessons[1] })
  })

  it('heißt „weitermachen“, sobald etwas erledigt ist, auch ohne zuletzt geöffnete Lektion', () => {
    expect(resumeTarget(lessons, new Set([10]), null)).toEqual({ state: 'continue', lesson: lessons[1] })
  })

  it('heißt „weitermachen“, wenn eine Lektion geöffnet, aber nichts erledigt wurde', () => {
    expect(resumeTarget(lessons, new Set(), 10)).toEqual({ state: 'continue', lesson: lessons[0] })
  })

  it('meldet den abgeschlossenen Kurs mit der letzten Lektion', () => {
    expect(resumeTarget(lessons, new Set([10, 20, 30]), 20)).toEqual({ state: 'done', lesson: lessons[2] })
  })
})
```

- [ ] **Step 4: Tests laufen lassen und Fehlschlag prüfen**

Run: `yarn test`
Expected: FAIL, beide Dateien melden, dass `app/utils/sections.js` bzw. `app/utils/progress.js` nicht gefunden wird.

- [ ] **Step 5: `sections.js` schreiben**

`app/utils/sections.js`:

```js
export const SECTIONS = [
  { key: 'start', label: 'Start' },
  { key: 'html', label: 'HTML' },
  { key: 'css', label: 'CSS' },
  { key: 'js', label: 'JavaScript' },
  { key: 'abschluss', label: 'Abschluss' }
]

export function sectionLabel(key) {
  return SECTIONS.find(section => section.key === key)?.label ?? key
}

export function groupBySection(lessons) {
  const known = SECTIONS.map(section => section.key)
  const unknown = [...new Set(lessons.map(lesson => lesson.section))].filter(key => !known.includes(key))

  return [...known, ...unknown]
    .map(key => ({
      key,
      label: sectionLabel(key),
      lessons: lessons.filter(lesson => lesson.section === key)
    }))
    .filter(group => group.lessons.length > 0)
}
```

- [ ] **Step 6: `progress.js` schreiben**

`app/utils/progress.js`:

```js
export function countCompleted(lessons, completedIds) {
  const done = lessons.filter(lesson => completedIds.has(lesson.id)).length
  return { done, total: lessons.length }
}

export function percentComplete(lessons, completedIds) {
  const { done, total } = countCompleted(lessons, completedIds)
  return total === 0 ? 0 : Math.floor((done / total) * 100)
}

export function resumeTarget(lessons, completedIds, lastLessonId) {
  if (lessons.length === 0) return { state: 'empty', lesson: null }

  const open = lessons.filter(lesson => !completedIds.has(lesson.id))
  if (open.length === 0) return { state: 'done', lesson: lessons[lessons.length - 1] }

  const lastOpened = open.find(lesson => lesson.id === lastLessonId)
  if (lastOpened) return { state: 'continue', lesson: lastOpened }

  const started = lastLessonId != null || open.length < lessons.length
  return { state: started ? 'continue' : 'start', lesson: open[0] }
}
```

- [ ] **Step 7: Tests laufen lassen**

Run: `yarn test`
Expected: PASS, 2 Dateien, 22 Tests.

- [ ] **Step 8: Commit**

```powershell
git add package.json yarn.lock app/utils/sections.js app/utils/progress.js tests/unit
git commit -m "Add section grouping and progress logic with tests"
```

---

### Task 2: Deutsche Meldungen für Anmeldefehler

**Files:**
- Create: `app/utils/authErrors.js`
- Test: `tests/unit/authErrors.test.js`

**Interfaces:**
- Produces:
  - `authErrorMessage(error: { code?: string } | null): string` (leerer String bei `null`)
  - `isExistingAccountSignup(data: { user?: { identities?: unknown[] } } | null): boolean`
  - `EXISTING_ACCOUNT_MESSAGE: string`

- [ ] **Step 1: Tests schreiben**

`tests/unit/authErrors.test.js`:

```js
import { describe, expect, it } from 'vitest'
import { EXISTING_ACCOUNT_MESSAGE, authErrorMessage, isExistingAccountSignup } from '../../app/utils/authErrors.js'

describe('authErrorMessage', () => {
  it('ist leer, wenn es keinen Fehler gibt', () => {
    expect(authErrorMessage(null)).toBe('')
  })

  it('übersetzt falsche Zugangsdaten', () => {
    expect(authErrorMessage({ code: 'invalid_credentials' })).toBe('E-Mail-Adresse oder Passwort stimmen nicht.')
  })

  it('übersetzt ein unbestätigtes Konto', () => {
    expect(authErrorMessage({ code: 'email_not_confirmed' })).toContain('bestätige')
  })

  it('übersetzt ein vorhandenes Konto für beide Fehlercodes gleich', () => {
    expect(authErrorMessage({ code: 'user_already_exists' })).toBe(EXISTING_ACCOUNT_MESSAGE)
    expect(authErrorMessage({ code: 'email_exists' })).toBe(EXISTING_ACCOUNT_MESSAGE)
  })

  it('übersetzt ein zu schwaches Passwort', () => {
    expect(authErrorMessage({ code: 'weak_password' })).toContain('8 Zeichen')
  })

  it('übersetzt einen abgelaufenen Link', () => {
    expect(authErrorMessage({ code: 'otp_expired' })).toContain('abgelaufen')
  })

  it('liefert eine allgemeine Meldung für unbekannte Codes und Netzwerkfehler ohne Code', () => {
    const fallback = 'Das hat nicht geklappt. Versuch es bitte noch einmal.'
    expect(authErrorMessage({ code: 'something_new' })).toBe(fallback)
    expect(authErrorMessage({ message: 'Failed to fetch' })).toBe(fallback)
  })
})

describe('isExistingAccountSignup', () => {
  it('erkennt die verschleierte Antwort für eine schon registrierte Adresse', () => {
    expect(isExistingAccountSignup({ user: { identities: [] } })).toBe(true)
  })

  it('ist falsch bei einer echten Neuregistrierung', () => {
    expect(isExistingAccountSignup({ user: { identities: [{ provider: 'email' }] } })).toBe(false)
  })

  it('ist falsch ohne Nutzer oder ohne Identitätsliste', () => {
    expect(isExistingAccountSignup(null)).toBe(false)
    expect(isExistingAccountSignup({ user: null })).toBe(false)
    expect(isExistingAccountSignup({ user: {} })).toBe(false)
  })
})
```

- [ ] **Step 2: Tests laufen lassen und Fehlschlag prüfen**

Run: `yarn test tests/unit/authErrors.test.js`
Expected: FAIL, `app/utils/authErrors.js` wird nicht gefunden.

- [ ] **Step 3: `authErrors.js` schreiben**

`app/utils/authErrors.js`:

```js
export const EXISTING_ACCOUNT_MESSAGE = 'Mit dieser E-Mail-Adresse gibt es bereits ein Konto. Melde dich an oder setze dein Passwort zurück.'

const FALLBACK_MESSAGE = 'Das hat nicht geklappt. Versuch es bitte noch einmal.'

const MESSAGES = {
  invalid_credentials: 'E-Mail-Adresse oder Passwort stimmen nicht.',
  email_not_confirmed: 'Bitte bestätige zuerst deine E-Mail-Adresse über den Link in unserer Mail.',
  user_already_exists: EXISTING_ACCOUNT_MESSAGE,
  email_exists: EXISTING_ACCOUNT_MESSAGE,
  weak_password: 'Das Passwort ist zu schwach. Nimm mindestens 8 Zeichen.',
  same_password: 'Das neue Passwort muss sich vom alten unterscheiden.',
  email_address_invalid: 'Diese E-Mail-Adresse ist ungültig.',
  email_address_not_authorized: 'An diese Adresse können wir gerade keine Mail senden.',
  over_email_send_rate_limit: 'Es wurden gerade zu viele Mails verschickt. Versuch es später noch einmal.',
  over_request_rate_limit: 'Zu viele Versuche. Warte kurz und versuch es noch einmal.',
  otp_expired: 'Der Link ist abgelaufen oder wurde schon benutzt.'
}

export function authErrorMessage(error) {
  if (!error) return ''
  return MESSAGES[error.code] ?? FALLBACK_MESSAGE
}

export function isExistingAccountSignup(data) {
  const identities = data?.user?.identities
  return Array.isArray(identities) && identities.length === 0
}
```

- [ ] **Step 4: Tests laufen lassen**

Run: `yarn test`
Expected: PASS, 3 Dateien, 32 Tests.

- [ ] **Step 5: Commit**

```powershell
git add app/utils/authErrors.js tests/unit/authErrors.test.js
git commit -m "Add German auth error messages with tests"
```

---

### Task 3: Datenbankschema, Zugriffsregeln und Beispiel-Lektionen

**Files:**
- Create: `supabase/tests/rls.sql`
- Create: `supabase/migrations/<Zeitstempel>_course_schema.sql` (über die CLI erzeugt)
- Create: `supabase/seeds/sample_lessons.sql`

**Interfaces:**
- Produces:
  - Tabelle `public.lessons(id bigint, slug, title, summary, position, section, content, solution, published, created_at, updated_at)`
  - Tabelle `public.lesson_progress(user_id uuid, lesson_id bigint, completed_at)` mit Primärschlüssel `(user_id, lesson_id)`
  - Tabelle `public.profiles(user_id uuid, last_lesson_id bigint, updated_at)`
  - Erlaubte Rücksprungadressen `http://localhost:3000/**` in der Supabase-Auth-Konfiguration

- [ ] **Step 1: RLS-Prüfung schreiben**

`supabase/tests/rls.sql`:

```sql
-- Prüft die Zugriffsregeln. Alles läuft in einer Transaktion und wird zurückgerollt.
-- Erfolg: Die letzte Abfrage liefert 'rls ok'. Jede verletzte Regel bricht mit einer Meldung ab.
begin;

do $$
declare
  user_a uuid := gen_random_uuid();
  user_b uuid := gen_random_uuid();
  draft_id bigint;
  public_id bigint;
  n integer;
begin
  insert into auth.users (id, instance_id, aud, role, email) values
    (user_a, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-a@example.test'),
    (user_b, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls-b@example.test');

  insert into public.lessons (slug, title, summary, position, section, content, published) values
    ('rls-test-draft', 'Entwurf', 'x', 900001, 'start', 'x', false),
    ('rls-test-public', 'Öffentlich', 'x', 900002, 'start', 'x', true);
  select id into draft_id from public.lessons where slug = 'rls-test-draft';
  select id into public_id from public.lessons where slug = 'rls-test-public';

  insert into public.lesson_progress (user_id, lesson_id) values (user_b, public_id);
  insert into public.profiles (user_id, last_lesson_id) values (user_b, public_id);

  -- Unangemeldet
  perform set_config('request.jwt.claims', '{"role":"anon"}', true);
  set local role anon;

  select count(*) into n from public.lessons where slug = 'rls-test-draft';
  assert n = 0, 'anon sieht eine unveröffentlichte Lektion';
  select count(*) into n from public.lessons where slug = 'rls-test-public';
  assert n = 1, 'anon sieht eine veröffentlichte Lektion nicht';

  begin
    update public.lessons set title = 'geändert' where slug = 'rls-test-public';
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
    select count(*) into n from public.profiles;
    assert n = 0, 'anon sieht Profile';
  exception when insufficient_privilege then null;
  end;

  -- Angemeldet als Nutzer A
  perform set_config('request.jwt.claims', json_build_object('sub', user_a, 'role', 'authenticated')::text, true);
  set local role authenticated;

  select count(*) into n from public.lessons where slug = 'rls-test-draft';
  assert n = 0, 'Nutzer sieht eine unveröffentlichte Lektion';

  select count(*) into n from public.lesson_progress;
  assert n = 0, 'A sieht fremden Fortschritt';
  select count(*) into n from public.profiles;
  assert n = 0, 'A sieht ein fremdes Profil';

  begin
    insert into public.lesson_progress (user_id, lesson_id) values (user_b, draft_id);
    assert false, 'A konnte Fortschritt für B anlegen';
  exception when insufficient_privilege then null;
  end;

  delete from public.lesson_progress where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte Fortschritt von B löschen';

  update public.profiles set last_lesson_id = null where user_id = user_b;
  get diagnostics n = row_count;
  assert n = 0, 'A konnte das Profil von B ändern';

  begin
    insert into public.profiles (user_id, last_lesson_id) values (gen_random_uuid(), public_id);
    assert false, 'A konnte ein fremdes Profil anlegen';
  exception when insufficient_privilege then null;
  end;

  insert into public.lesson_progress (user_id, lesson_id) values (user_a, public_id);
  select count(*) into n from public.lesson_progress;
  assert n = 1, 'A sieht den eigenen Fortschritt nicht';

  insert into public.profiles (user_id, last_lesson_id) values (user_a, public_id);
  update public.profiles set last_lesson_id = null where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte das eigene Profil nicht ändern';

  delete from public.lesson_progress where user_id = user_a;
  get diagnostics n = row_count;
  assert n = 1, 'A konnte den eigenen Fortschritt nicht löschen';

  reset role;
end $$;

rollback;

select 'rls ok' as result;
```

- [ ] **Step 2: Prüfung ausführen und Fehlschlag sehen**

Den Inhalt von `supabase/tests/rls.sql` mit `mcp__supabase__execute_sql` ausführen.
Expected: Fehler `relation "public.lessons" does not exist`.

- [ ] **Step 3: Migrationsdatei erzeugen**

```powershell
yarn -s supabase migration new course_schema
```

Expected: Meldung mit dem Pfad `supabase/migrations/<Zeitstempel>_course_schema.sql`.

- [ ] **Step 4: Schema in die Migrationsdatei schreiben**

Inhalt der erzeugten Datei:

```sql
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
```

- [ ] **Step 5: Migration einspielen**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db push
```

Expected: Die Migration `course_schema` wird als angewendet gemeldet. Falls die CLI eine Bestätigung verlangt, den Befehl mit `--yes` wiederholen.

- [ ] **Step 6: RLS-Prüfung erneut ausführen**

Den Inhalt von `supabase/tests/rls.sql` mit `mcp__supabase__execute_sql` ausführen.
Expected: Ergebniszeile `rls ok`.

- [ ] **Step 7: Sicherheitshinweise prüfen**

`mcp__supabase__get_advisors` mit Typ `security` aufrufen.
Expected: Keine Hinweise zu `lessons`, `lesson_progress`, `profiles` oder `set_updated_at`. Jeden Hinweis zu diesen Objekten beheben, bevor es weitergeht.

- [ ] **Step 8: Beispiel-Lektionen schreiben**

`supabase/seeds/sample_lessons.sql`:

````sql
-- Beispiel-Lektionen für die Entwicklung der Plattform.
-- Werden durch den echten Kursinhalt ersetzt.
insert into public.lessons (slug, title, summary, position, section, content, solution, published) values
(
  'willkommen', 'Willkommen', 'Was wir bauen und wie der Kurs funktioniert.', 1, 'start',
  $md$
## Was dich erwartet

In diesem Kurs baust du eine kleine **Todo-App**. Du brauchst dafür keine Vorkenntnisse.

- Du arbeitest auf deinem eigenen Rechner.
- Jede Lektion endet mit einer Musterlösung.

Mehr über Nuxt findest du in der [Dokumentation](https://nuxt.com).
$md$,
  null, true
),
(
  'die-erste-seite', 'Die erste Seite', 'Wir schreiben das erste HTML in app.vue.', 2, 'html',
  $md$
## Das Template

Öffne die Datei `app/app.vue` und ersetze den Inhalt:

```vue [app/app.vue]
<template>
  <h1>Meine Todos</h1>
</template>
```

Speichere die Datei. Der Browser zeigt die Überschrift sofort an.

### Was ist ein Tag?

Ein Tag wie `<h1>` sagt dem Browser, **was** der Text ist.
$md$,
  $md$
```vue [app/app.vue]
<template>
  <h1>Meine Todos</h1>
</template>
```
$md$,
  true
),
(
  'tailwind-einrichten', 'Tailwind einrichten', 'Wir installieren Tailwind und setzen die ersten Klassen.', 3, 'css',
  $md$
## Installation

Führe im Terminal diesen Befehl aus:

```bash
npm install tailwindcss @tailwindcss/vite
```

Danach bekommt die Überschrift ihre ersten Klassen:

```html
<h1 class="text-3xl font-bold">Meine Todos</h1>
```
$md$,
  $md$
```html
<h1 class="text-3xl font-bold">Meine Todos</h1>
```
$md$,
  true
),
(
  'daten-anzeigen', 'Daten anzeigen', 'Wir zeigen eine Liste aus JavaScript an.', 4, 'js',
  $md$
## Eine Liste im Script

```vue [app/app.vue]
<script setup>
const todos = ref(['Einkaufen', 'Lernen'])
</script>

<template>
  <ul>
    <li v-for="todo in todos" :key="todo">{{ todo }}</li>
  </ul>
</template>
```

Mit `v-for` wiederholt Vue das `<li>` für jeden Eintrag.
$md$,
  $md$
```vue [app/app.vue]
<script setup>
const todos = ref(['Einkaufen', 'Lernen'])
</script>

<template>
  <ul>
    <li v-for="todo in todos" :key="todo">{{ todo }}</li>
  </ul>
</template>
```
$md$,
  true
),
(
  'geschafft', 'Geschafft', 'Rückblick und Ideen zum Weitermachen.', 5, 'abschluss',
  $md$
## Das hast du gebaut

Eine Todo-App mit HTML, CSS und JavaScript. Glückwunsch!
$md$,
  null, true
),
(
  'entwurf', 'Entwurf', 'Diese Lektion ist nicht veröffentlicht.', 6, 'js',
  $md$
## Nicht sichtbar

Dieser Text darf auf der Seite nicht erscheinen.
$md$,
  null, false
)
on conflict (slug) do nothing;
````

- [ ] **Step 9: Beispiel-Lektionen einspielen und prüfen**

Den Inhalt von `supabase/seeds/sample_lessons.sql` mit `mcp__supabase__execute_sql` ausführen, danach:

```sql
select position, slug, section, published from public.lessons order by position;
```

Expected: 6 Zeilen, Positionen 1 bis 6, nur `entwurf` mit `published = false`.

- [ ] **Step 10: Rücksprungadressen für die Anmeldung erlauben**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; $body = @{ site_url = 'http://localhost:3000'; uri_allow_list = 'http://localhost:3000/**' } | ConvertTo-Json; Invoke-RestMethod -Method Patch -Uri 'https://api.supabase.com/v1/projects/vsoqzbtusinpkeabygxg/config/auth' -Headers @{ Authorization = "Bearer $env:SUPABASE_ACCESS_TOKEN" } -ContentType 'application/json' -Body $body | Select-Object site_url, uri_allow_list
```

Expected: Ausgabe mit `site_url = http://localhost:3000` und `uri_allow_list = http://localhost:3000/**`.

- [ ] **Step 11: Commit**

```powershell
git add supabase/migrations supabase/tests supabase/seeds
git commit -m "Add course schema, RLS policies, RLS test and sample lessons"
```

---

### Task 4: Gestaltungsgrundlage und Seitenrahmen

**Files:**
- Modify: `package.json`, `nuxt.config.ts`, `app/assets/css/main.css`, `app/app.vue`
- Create: `app/layouts/default.vue`, `app/components/AppHeader.vue`, `app/components/AppFooter.vue`, `app/error.vue`, `app/pages/impressum.vue`, `app/pages/datenschutz.vue`, `app/pages/index.vue` (vorläufig)

**Interfaces:**
- Produces:
  - Tailwind-Farben `ember`, `abyss`, `carbon`, `ink`, `paper`, `fog`, `mist`, `steel`, `pewter`, `graphite`
  - CSS-Klassen `btn-primary`, `btn-secondary`, `btn-ghost`, `input`, `field-label`, `notice`, `text-link`, `lesson-prose`, `code-block`, `code-block-bar`
  - Layout `default` mit Kopf und Fuß
  - Global verfügbare Komponente `<MDC>`

- [ ] **Step 1: Abhängigkeiten installieren**

```powershell
yarn add @nuxtjs/mdc @fontsource-variable/inter
```

Inter wird damit selbst gehostet; es gibt keine Anfrage an Google Fonts.

- [ ] **Step 2: `nuxt.config.ts` ersetzen**

```ts
import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: false },
  modules: ['@nuxtjs/supabase', '@nuxtjs/mdc'],
  css: ['~/assets/css/main.css'],
  app: {
    head: {
      htmlAttrs: { lang: 'de' },
      titleTemplate: '%s · Nuxt für Einsteiger'
    }
  },
  vite: {
    plugins: [tailwindcss()]
  },
  supabase: {
    // Keine Seite erzwingt einen Login; /profil schützt die Middleware "auth".
    redirect: false,
    types: false
  },
  mdc: {
    highlight: {
      theme: 'github-light',
      langs: ['vue', 'html', 'css', 'js', 'json', 'bash']
    }
  }
})
```

- [ ] **Step 3: `app/assets/css/main.css` ersetzen**

```css
@import "tailwindcss";
@import "@fontsource-variable/inter";

@theme {
  --color-ember: #ff5900;
  --color-abyss: #000710;
  --color-carbon: #15191e;
  --color-ink: #000000;
  --color-paper: #ffffff;
  --color-fog: #f3f3f7;
  --color-mist: #b9bbc6;
  --color-steel: #8b8d98;
  --color-pewter: #6f737b;
  --color-graphite: #60646c;

  --font-sans: 'Inter Variable', ui-sans-serif, system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
}

@layer base {
  html {
    background-color: var(--color-paper);
    color: var(--color-graphite);
    letter-spacing: -0.01em;
    font-feature-settings: "calt" 0, "liga" 0, "ss03", "cv01", "cv10";
  }

  :focus-visible {
    outline: 2px solid var(--color-ink);
    outline-offset: 2px;
  }
}

@layer components {
  .btn-primary {
    @apply inline-flex items-center justify-center gap-2 rounded-xl bg-ember px-4 py-2 text-sm font-semibold text-paper transition-opacity hover:opacity-90 disabled:cursor-not-allowed disabled:opacity-50;
  }

  .btn-secondary {
    @apply inline-flex items-center justify-center gap-2 rounded-xl border border-mist bg-paper px-4 py-2 text-sm font-semibold text-ink transition-colors hover:bg-fog disabled:cursor-not-allowed disabled:opacity-50;
  }

  .btn-ghost {
    @apply inline-flex items-center gap-2 text-sm font-medium text-ink underline-offset-4 hover:underline;
  }

  .text-link {
    @apply text-ink underline underline-offset-4;
  }

  .field-label {
    @apply mb-2 block text-sm font-medium text-ink;
  }

  .input {
    @apply block w-full rounded-xl border border-mist bg-paper px-4 py-3 text-base text-ink placeholder:text-steel;
  }

  .notice {
    @apply rounded-xl bg-fog px-4 py-3 text-sm text-ink;
  }

  .code-block {
    @apply my-6 overflow-hidden rounded-xl bg-fog;
  }

  .code-block-bar {
    @apply flex items-center justify-between gap-4 border-b border-mist/60 px-4 py-2 text-xs text-pewter;
  }

  .code-block pre {
    @apply overflow-x-auto p-4 text-sm leading-relaxed;
    letter-spacing: 0;
  }

  .lesson-prose {
    @apply max-w-[640px] text-base leading-relaxed;
  }

  .lesson-prose h2 {
    @apply mb-4 mt-12 text-2xl font-medium text-ink first:mt-0;
  }

  .lesson-prose h3 {
    @apply mb-3 mt-8 text-xl font-medium text-ink;
  }

  .lesson-prose :is(h2, h3) a {
    @apply no-underline;
  }

  .lesson-prose p {
    @apply my-4;
  }

  .lesson-prose ul {
    @apply my-4 list-disc space-y-2 pl-6;
  }

  .lesson-prose ol {
    @apply my-4 list-decimal space-y-2 pl-6;
  }

  .lesson-prose strong {
    @apply font-semibold text-ink;
  }

  .lesson-prose a {
    @apply text-ink underline underline-offset-4;
  }

  .lesson-prose :not(pre) > code {
    @apply rounded-md bg-fog px-1.5 py-0.5 text-[0.9em] text-ink;
    letter-spacing: 0;
  }

  .lesson-prose blockquote {
    @apply my-6 rounded-xl bg-fog px-4 py-3 text-ink;
  }
}
```

- [ ] **Step 4: `app/app.vue` ersetzen**

```vue
<template>
  <NuxtLayout>
    <NuxtRouteAnnouncer />
    <NuxtPage />
  </NuxtLayout>
</template>
```

- [ ] **Step 5: Layout schreiben**

`app/layouts/default.vue`:

```vue
<template>
  <div class="flex min-h-screen flex-col bg-paper">
    <AppHeader />
    <main class="flex-1">
      <slot />
    </main>
    <AppFooter />
  </div>
</template>
```

- [ ] **Step 6: Kopfzeile schreiben**

`app/components/AppHeader.vue`:

```vue
<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()

async function logout() {
  await client.auth.signOut()
  user.value = null
  await navigateTo('/')
}
</script>

<template>
  <header class="border-b border-mist/60">
    <div class="mx-auto flex max-w-[1200px] items-center justify-between gap-4 px-4 py-4 sm:px-6">
      <NuxtLink to="/" class="text-xl font-medium tracking-[-0.02em] text-ink">
        Nuxt für Einsteiger
      </NuxtLink>
      <nav class="flex items-center gap-4 text-sm font-medium text-ink" aria-label="Konto">
        <template v-if="user">
          <NuxtLink to="/profil" class="hover:underline">Profil</NuxtLink>
          <button type="button" class="hover:underline" @click="logout">Abmelden</button>
        </template>
        <template v-else>
          <NuxtLink to="/login" class="hover:underline">Anmelden</NuxtLink>
          <NuxtLink to="/registrieren" class="btn-primary">Konto erstellen</NuxtLink>
        </template>
      </nav>
    </div>
  </header>
</template>
```

- [ ] **Step 7: Fußzeile schreiben**

`app/components/AppFooter.vue`:

```vue
<template>
  <footer class="bg-abyss">
    <div class="mx-auto flex max-w-[1200px] flex-col gap-4 px-4 py-12 text-sm text-mist sm:flex-row sm:items-center sm:justify-between sm:px-6">
      <p class="font-semibold text-paper">Nuxt für Einsteiger</p>
      <nav class="flex gap-6" aria-label="Rechtliches">
        <NuxtLink to="/impressum" class="hover:text-paper">Impressum</NuxtLink>
        <NuxtLink to="/datenschutz" class="hover:text-paper">Datenschutz</NuxtLink>
      </nav>
    </div>
  </footer>
</template>
```

- [ ] **Step 8: Fehlerseite schreiben**

`app/error.vue`:

```vue
<script setup>
const props = defineProps({
  error: { type: Object, default: () => ({}) }
})

const notFound = computed(() => props.error?.statusCode === 404)

useSeoMeta({ title: () => (notFound.value ? 'Seite nicht gefunden' : 'Fehler') })
</script>

<template>
  <div class="flex min-h-screen flex-col bg-paper">
    <main class="mx-auto w-full max-w-[1200px] flex-1 px-4 py-20 sm:px-6">
      <p class="text-sm font-medium text-pewter">{{ notFound ? 'Fehler 404' : 'Fehler' }}</p>
      <h1 class="mt-2 text-4xl font-medium tracking-[-0.02em] text-ink">
        {{ notFound ? 'Diese Seite gibt es nicht.' : 'Da ist etwas schiefgegangen.' }}
      </h1>
      <p class="mt-4 max-w-[640px]">
        {{ notFound
          ? 'Vielleicht hat sich die Adresse geändert, oder die Lektion ist noch nicht veröffentlicht.'
          : 'Die Seite konnte gerade nicht geladen werden. Versuch es in ein paar Minuten noch einmal.' }}
      </p>
      <button type="button" class="btn-primary mt-8" @click="clearError({ redirect: '/' })">
        Zur Übersicht
      </button>
    </main>
  </div>
</template>
```

- [ ] **Step 9: Platzhalterseiten schreiben**

`app/pages/impressum.vue`:

```vue
<script setup>
useSeoMeta({ title: 'Impressum' })
</script>

<template>
  <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Impressum</h1>
    <p class="notice mt-8 max-w-[640px]">Platzhalter: Der Text für das Impressum fehlt noch.</p>
  </div>
</template>
```

`app/pages/datenschutz.vue`:

```vue
<script setup>
useSeoMeta({ title: 'Datenschutz' })
</script>

<template>
  <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Datenschutz</h1>
    <p class="notice mt-8 max-w-[640px]">Platzhalter: Die Datenschutzerklärung fehlt noch.</p>
  </div>
</template>
```

- [ ] **Step 10: Vorläufige Startseite schreiben**

`app/pages/index.vue` (wird in Task 6 ersetzt):

```vue
<script setup>
useSeoMeta({ title: 'Start' })
</script>

<template>
  <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
    <h1 class="text-5xl font-medium tracking-[-0.025em] text-ink">Nuxt für Einsteiger</h1>
  </div>
</template>
```

- [ ] **Step 11: Bauen und im Browser prüfen**

Run: `yarn build`
Expected: Build endet ohne Fehler und ohne die Warnung zu `database.types.ts`.

Run: `yarn dev` im Hintergrund starten, dann:

```powershell
(curl.exe -s http://localhost:3000/) -match 'lang="de"'; (curl.exe -s http://localhost:3000/impressum) -match 'Platzhalter'; curl.exe -s -o NUL -w "%{http_code}" http://localhost:3000/gibt-es-nicht
```

Expected: `True`, `True`, `404`.

Im Browser `http://localhost:3000/` öffnen und prüfen: Schrift ist Inter, „Konto erstellen“ ist orange mit 12px-Radius, der Fuß ist fast schwarz, `/gibt-es-nicht` zeigt „Diese Seite gibt es nicht.“ und der Button führt zurück zur Startseite.

- [ ] **Step 12: Commit**

```powershell
git add package.json yarn.lock nuxt.config.ts app
git commit -m "Add design tokens, layout, header, footer and error page"
```

---

### Task 5: Anmeldung, Registrierung und Passwort-Reset

**Files:**
- Create: `app/components/AuthForm.vue`, `app/middleware/auth.js`
- Create: `app/pages/login.vue`, `app/pages/registrieren.vue`, `app/pages/confirm.vue`, `app/pages/passwort-vergessen.vue`, `app/pages/passwort-neu.vue`

**Interfaces:**
- Consumes: `authErrorMessage`, `isExistingAccountSignup`, `EXISTING_ACCOUNT_MESSAGE` aus Task 2; CSS-Klassen aus Task 4
- Produces:
  - `<AuthForm title submit-label :pending :error :notice :show-email :show-password password-autocomplete @submit="({ email, password }) => …">` mit Standard-Slot für Links unter dem Formular
  - Middleware `auth`: leitet Unangemeldete nach `/login?weiter=<Zielpfad>` um
  - `/login` wertet `?weiter=` aus und akzeptiert nur Pfade, die mit genau einem `/` beginnen

- [ ] **Step 1: `AuthForm` schreiben**

`app/components/AuthForm.vue`:

```vue
<script setup>
defineProps({
  title: { type: String, required: true },
  submitLabel: { type: String, required: true },
  pending: { type: Boolean, default: false },
  error: { type: String, default: '' },
  notice: { type: String, default: '' },
  showEmail: { type: Boolean, default: true },
  showPassword: { type: Boolean, default: true },
  passwordAutocomplete: { type: String, default: 'current-password' }
})

const emit = defineEmits(['submit'])

const email = ref('')
const password = ref('')
</script>

<template>
  <div class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">{{ title }}</h1>

    <p v-if="notice" class="notice mt-8" role="status">{{ notice }}</p>

    <form v-else class="mt-8 space-y-4" @submit.prevent="emit('submit', { email, password })">
      <div v-if="showEmail">
        <label class="field-label" for="auth-email">E-Mail-Adresse</label>
        <input id="auth-email" v-model.trim="email" class="input" type="email" autocomplete="email" required>
      </div>
      <div v-if="showPassword">
        <label class="field-label" for="auth-password">Passwort</label>
        <input
          id="auth-password"
          v-model="password"
          class="input"
          type="password"
          :autocomplete="passwordAutocomplete"
          minlength="8"
          required
        >
        <p v-if="passwordAutocomplete === 'new-password'" class="mt-2 text-xs text-pewter">Mindestens 8 Zeichen.</p>
      </div>

      <p v-if="error" class="notice" role="alert">{{ error }}</p>

      <button type="submit" class="btn-primary w-full" :disabled="pending">
        {{ pending ? 'Einen Moment …' : submitLabel }}
      </button>
    </form>

    <div class="mt-6 space-y-2 text-sm">
      <slot />
    </div>
  </div>
</template>
```

- [ ] **Step 2: Middleware schreiben**

`app/middleware/auth.js`:

```js
export default defineNuxtRouteMiddleware((to) => {
  const user = useSupabaseUser()
  if (!user.value) {
    return navigateTo({ path: '/login', query: { weiter: to.fullPath } })
  }
})
```

- [ ] **Step 3: Login-Seite schreiben**

`app/pages/login.vue`:

```vue
<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()
const route = useRoute()

const pending = ref(false)
const error = ref('')

// Nur interne Pfade zulassen, damit ?weiter= nicht auf fremde Seiten umleiten kann.
const target = computed(() => {
  const next = route.query.weiter
  return typeof next === 'string' && next.startsWith('/') && !next.startsWith('//') ? next : '/profil'
})

if (user.value) await navigateTo(target.value)

async function login({ email, password }) {
  pending.value = true
  error.value = ''
  const { error: authError } = await client.auth.signInWithPassword({ email, password })
  if (authError) {
    error.value = authErrorMessage(authError)
    pending.value = false
    return
  }
  // Der Nutzer-State des Moduls aktualisiert sich erst verzögert; die Middleware braucht ihn sofort.
  const { data } = await client.auth.getClaims()
  user.value = data?.claims ?? null
  pending.value = false
  await navigateTo(target.value)
}

useSeoMeta({ title: 'Anmelden' })
</script>

<template>
  <AuthForm title="Anmelden" submit-label="Anmelden" :pending="pending" :error="error" @submit="login">
    <p><NuxtLink to="/passwort-vergessen" class="text-link">Passwort vergessen?</NuxtLink></p>
    <p>Noch kein Konto? <NuxtLink to="/registrieren" class="text-link">Konto erstellen</NuxtLink></p>
  </AuthForm>
</template>
```

- [ ] **Step 4: Registrierungsseite schreiben**

`app/pages/registrieren.vue`:

```vue
<script setup>
const client = useSupabaseClient()

const pending = ref(false)
const error = ref('')
const notice = ref('')

async function register({ email, password }) {
  pending.value = true
  error.value = ''
  const { data, error: authError } = await client.auth.signUp({
    email,
    password,
    options: { emailRedirectTo: `${window.location.origin}/confirm` }
  })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
  } else if (isExistingAccountSignup(data)) {
    error.value = EXISTING_ACCOUNT_MESSAGE
  } else {
    notice.value = 'Fast geschafft: Wir haben dir eine Mail geschickt. Klick auf den Link darin, um dein Konto zu bestätigen.'
  }
}

useSeoMeta({ title: 'Konto erstellen' })
</script>

<template>
  <AuthForm
    title="Konto erstellen"
    submit-label="Konto erstellen"
    password-autocomplete="new-password"
    :pending="pending"
    :error="error"
    :notice="notice"
    @submit="register"
  >
    <p>Schon ein Konto? <NuxtLink to="/login" class="text-link">Anmelden</NuxtLink></p>
  </AuthForm>
</template>
```

- [ ] **Step 5: Bestätigungsseite schreiben**

`app/pages/confirm.vue`:

```vue
<script setup>
const user = useSupabaseUser()
const route = useRoute()

// Supabase hängt bei abgelaufenen Links ?error=… an die Adresse.
const failed = ref(Boolean(route.query.error))

watch(user, (current) => {
  if (current) navigateTo('/profil')
}, { immediate: true })

onMounted(() => {
  // Wird der Link in einem anderen Browser geöffnet, entsteht keine Sitzung. Dann nicht endlos warten.
  setTimeout(() => {
    if (!user.value) failed.value = true
  }, 5000)
})

useSeoMeta({ title: 'Konto bestätigen' })
</script>

<template>
  <div class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <template v-if="failed">
      <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Fast geschafft</h1>
      <p class="mt-4">
        Wir konnten dich nicht automatisch anmelden. Wenn du den Link gerade zum ersten Mal geklickt hast,
        ist dein Konto trotzdem bestätigt und du kannst dich anmelden.
      </p>
      <p class="mt-4">Ist der Link abgelaufen, registriere dich noch einmal mit derselben Adresse.</p>
      <NuxtLink to="/login" class="btn-primary mt-8">Zur Anmeldung</NuxtLink>
    </template>
    <template v-else>
      <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Dein Konto wird bestätigt …</h1>
      <p class="mt-4" role="status">Einen Moment, wir melden dich an.</p>
    </template>
  </div>
</template>
```

- [ ] **Step 6: Seite „Passwort vergessen“ schreiben**

`app/pages/passwort-vergessen.vue`:

```vue
<script setup>
const client = useSupabaseClient()

const pending = ref(false)
const error = ref('')
const notice = ref('')

async function requestReset({ email }) {
  pending.value = true
  error.value = ''
  const { error: authError } = await client.auth.resetPasswordForEmail(email, {
    redirectTo: `${window.location.origin}/passwort-neu`
  })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
  } else {
    notice.value = 'Wenn es zu dieser Adresse ein Konto gibt, haben wir dir eine Mail mit einem Link zum Zurücksetzen geschickt.'
  }
}

useSeoMeta({ title: 'Passwort vergessen' })
</script>

<template>
  <AuthForm
    title="Passwort vergessen"
    submit-label="Link schicken"
    :show-password="false"
    :pending="pending"
    :error="error"
    :notice="notice"
    @submit="requestReset"
  >
    <p><NuxtLink to="/login" class="text-link">Zurück zur Anmeldung</NuxtLink></p>
  </AuthForm>
</template>
```

- [ ] **Step 7: Seite „Neues Passwort“ schreiben**

`app/pages/passwort-neu.vue`:

```vue
<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()
const route = useRoute()

const pending = ref(false)
const error = ref('')
// Ohne Sitzung aus dem Reset-Link lässt sich kein Passwort setzen.
const invalidLink = ref(Boolean(route.query.error))

onMounted(() => {
  setTimeout(() => {
    if (!user.value) invalidLink.value = true
  }, 5000)
})

async function savePassword({ password }) {
  pending.value = true
  error.value = ''
  const { error: authError } = await client.auth.updateUser({ password })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
    return
  }
  await navigateTo('/profil')
}

useSeoMeta({ title: 'Neues Passwort' })
</script>

<template>
  <div v-if="invalidLink && !user" class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Der Link funktioniert nicht mehr</h1>
    <p class="mt-4">
      Er ist abgelaufen, wurde schon benutzt oder in einem anderen Browser geöffnet als dem,
      in dem du ihn angefordert hast.
    </p>
    <NuxtLink to="/passwort-vergessen" class="btn-primary mt-8">Neuen Link anfordern</NuxtLink>
  </div>
  <AuthForm
    v-else-if="user"
    title="Neues Passwort"
    submit-label="Passwort speichern"
    password-autocomplete="new-password"
    :show-email="false"
    :pending="pending"
    :error="error"
    @submit="savePassword"
  />
  <div v-else class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Neues Passwort</h1>
    <p class="mt-4" role="status">Einen Moment, wir prüfen deinen Link …</p>
  </div>
</template>
```

- [ ] **Step 8: Bauen und Fehlerpfade prüfen**

Run: `yarn build`
Expected: Build endet ohne Fehler.

Mit laufendem `yarn dev` im Browser prüfen:

1. `/login` mit einer nicht registrierten Adresse und beliebigem Passwort absenden. Expected: „E-Mail-Adresse oder Passwort stimmen nicht.“
2. `/confirm?error=access_denied&error_code=otp_expired` öffnen. Expected: sofort „Fast geschafft“ mit Button „Zur Anmeldung“, keine Ladeanzeige.
3. `/confirm` ohne Parameter öffnen. Expected: erst „Dein Konto wird bestätigt …“, nach 5 Sekunden „Fast geschafft“.
4. `/passwort-neu` ohne Sitzung öffnen. Expected: nach 5 Sekunden „Der Link funktioniert nicht mehr“ mit Button „Neuen Link anfordern“.
5. `/login?weiter=//evil.example` öffnen und den Seitenquelltext prüfen: Es gibt keinen Verweis auf `evil.example`.

Registrierung, Bestätigungslink und Reset-Mail werden in Task 9 mit einer echten Adresse geprüft.

- [ ] **Step 9: Commit**

```powershell
git add app/components/AuthForm.vue app/middleware app/pages
git commit -m "Add login, registration, confirmation and password reset pages"
```

---

### Task 6: Datenzugriff, Lektionsliste und Startseite

**Files:**
- Create: `app/composables/useLessons.js`, `app/composables/useProgress.js`, `app/composables/useProfile.js`
- Create: `app/components/SectionTag.vue`, `app/components/LessonList.vue`, `app/components/ProgressBar.vue`, `app/components/ResumeButton.vue`
- Modify: `app/pages/index.vue` (ersetzen)

**Interfaces:**
- Consumes: `groupBySection`, `sectionLabel`, `countCompleted`, `percentComplete`, `resumeTarget` aus Task 1; Tabellen aus Task 3
- Produces:
  - `useLessons()`: Rückgabe von `useAsyncData`; `data` ist `Lesson[]` mit `id, slug, title, summary, position, section`, Standard `[]`
  - `useLesson(slug: string)`: Rückgabe von `useAsyncData`; `data` zusätzlich mit `content, solution`; `error.statusCode` ist 404 bei unbekanntem Slug, 503 bei Datenbankfehler
  - `useProgress()`: `{ completedIds: ComputedRef<Set<number>>, completedAt: ComputedRef<Record<number, string>>, complete(lessonId): Promise<boolean>, uncomplete(lessonId): Promise<boolean> }`
  - `useProfile()`: `{ lastLessonId: Ref<number | null>, saveLastLesson(lessonId): Promise<void> }`
  - `<SectionTag section="js">`
  - `<LessonList :lessons :completed-ids :completed-at :current-slug show-summary show-counts>`
  - `<ProgressBar :percent label="Fortschritt">`
  - `<ResumeButton :lessons>`

- [ ] **Step 1: `useLessons` schreiben**

`app/composables/useLessons.js`:

```js
const LIST_COLUMNS = 'id, slug, title, summary, position, section'

export function useLessons() {
  const client = useSupabaseClient()

  return useAsyncData('lessons', async () => {
    const { data, error } = await client.from('lessons').select(LIST_COLUMNS).order('position')
    if (error) {
      throw createError({ statusCode: 503, statusMessage: 'Die Lektionen konnten nicht geladen werden.' })
    }
    return data
  }, { default: () => [] })
}

export function useLesson(slug) {
  const client = useSupabaseClient()

  return useAsyncData(`lesson-${slug}`, async () => {
    const { data, error } = await client
      .from('lessons')
      .select(`${LIST_COLUMNS}, content, solution`)
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

- [ ] **Step 2: `useProgress` schreiben**

`app/composables/useProgress.js`:

```js
export function useProgress() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  const { data: rows } = useAsyncData('progress', async () => {
    if (!user.value) return []
    const { data, error } = await client.from('lesson_progress').select('lesson_id, completed_at')
    return error ? [] : data
  }, { watch: [() => user.value?.sub], default: () => [] })

  const completedIds = computed(() => new Set(rows.value.map(row => row.lesson_id)))
  const completedAt = computed(() => Object.fromEntries(rows.value.map(row => [row.lesson_id, row.completed_at])))

  // Beide Funktionen ändern die Anzeige sofort und nehmen die Änderung zurück, wenn das Speichern scheitert.
  async function complete(lessonId) {
    if (!user.value) return false
    if (completedIds.value.has(lessonId)) return true

    const previous = rows.value
    rows.value = [...previous, { lesson_id: lessonId, completed_at: new Date().toISOString() }]
    const { error } = await client
      .from('lesson_progress')
      .upsert({ user_id: user.value.sub, lesson_id: lessonId }, { onConflict: 'user_id,lesson_id', ignoreDuplicates: true })
    if (error) {
      rows.value = previous
      return false
    }
    return true
  }

  async function uncomplete(lessonId) {
    if (!user.value) return false

    const previous = rows.value
    rows.value = previous.filter(row => row.lesson_id !== lessonId)
    const { error } = await client
      .from('lesson_progress')
      .delete()
      .eq('user_id', user.value.sub)
      .eq('lesson_id', lessonId)
    if (error) {
      rows.value = previous
      return false
    }
    return true
  }

  return { completedIds, completedAt, complete, uncomplete }
}
```

- [ ] **Step 3: `useProfile` schreiben**

`app/composables/useProfile.js`:

```js
export function useProfile() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  const { data: lastLessonId } = useAsyncData('profile', async () => {
    if (!user.value) return null
    const { data, error } = await client.from('profiles').select('last_lesson_id').maybeSingle()
    return error ? null : (data?.last_lesson_id ?? null)
  }, { watch: [() => user.value?.sub], default: () => null })

  async function saveLastLesson(lessonId) {
    if (!user.value) return
    lastLessonId.value = lessonId
    await client
      .from('profiles')
      .upsert({ user_id: user.value.sub, last_lesson_id: lessonId, updated_at: new Date().toISOString() })
  }

  return { lastLessonId, saveLastLesson }
}
```

- [ ] **Step 4: `SectionTag` schreiben**

`app/components/SectionTag.vue`:

```vue
<script setup>
defineProps({
  section: { type: String, required: true }
})
</script>

<template>
  <span class="inline-block rounded-md border border-mist px-2 py-0.5 text-xs font-medium text-ink">
    {{ sectionLabel(section) }}
  </span>
</template>
```

- [ ] **Step 5: `ProgressBar` schreiben**

`app/components/ProgressBar.vue`:

```vue
<script setup>
defineProps({
  percent: { type: Number, required: true },
  label: { type: String, default: 'Fortschritt' }
})
</script>

<template>
  <div>
    <div class="mb-2 flex justify-between text-sm">
      <span class="font-medium text-ink">{{ label }}</span>
      <span>{{ percent }} %</span>
    </div>
    <div
      class="h-2 overflow-hidden rounded-full bg-mist/40"
      role="progressbar"
      :aria-label="label"
      :aria-valuenow="percent"
      aria-valuemin="0"
      aria-valuemax="100"
    >
      <div class="h-full rounded-full bg-ember transition-[width]" :style="{ width: `${percent}%` }" />
    </div>
  </div>
</template>
```

- [ ] **Step 6: `LessonList` schreiben**

`app/components/LessonList.vue`:

```vue
<script setup>
const props = defineProps({
  lessons: { type: Array, required: true },
  completedIds: { type: Set, default: () => new Set() },
  completedAt: { type: Object, default: () => ({}) },
  currentSlug: { type: String, default: null },
  showSummary: { type: Boolean, default: false },
  showCounts: { type: Boolean, default: false }
})

const groups = computed(() => groupBySection(props.lessons))

// Feste Zeitzone, damit Server und Browser dasselbe Datum rendern.
function formatDate(iso) {
  return new Date(iso).toLocaleDateString('de-DE', { timeZone: 'Europe/Berlin' })
}
</script>

<template>
  <div class="space-y-8">
    <section v-for="group in groups" :key="group.key" :aria-label="group.label">
      <div class="mb-3 flex items-center justify-between gap-4">
        <SectionTag :section="group.key" />
        <span v-if="showCounts" class="text-xs text-pewter">
          {{ countCompleted(group.lessons, completedIds).done }} von {{ group.lessons.length }} erledigt
        </span>
      </div>
      <ol class="overflow-hidden rounded-xl border border-mist/60 bg-paper">
        <li v-for="lesson in group.lessons" :key="lesson.id" class="border-b border-mist/60 last:border-b-0">
          <NuxtLink
            :to="`/kurs/${lesson.slug}`"
            class="flex items-start gap-3 px-4 py-3 hover:bg-fog"
            :class="{ 'bg-fog': lesson.slug === currentSlug }"
            :aria-current="lesson.slug === currentSlug ? 'page' : undefined"
          >
            <span
              class="mt-0.5 flex size-5 shrink-0 items-center justify-center rounded-full border text-[10px] font-semibold"
              :class="completedIds.has(lesson.id) ? 'border-ember bg-ember text-paper' : 'border-mist text-pewter'"
            >
              <template v-if="completedIds.has(lesson.id)">
                <span aria-hidden="true">✓</span>
                <span class="sr-only">Erledigt:</span>
              </template>
              <span v-else aria-hidden="true">{{ lesson.position }}</span>
            </span>
            <span class="min-w-0 flex-1">
              <span class="block text-sm font-medium text-ink">{{ lesson.title }}</span>
              <span v-if="showSummary" class="mt-0.5 block text-sm">{{ lesson.summary }}</span>
            </span>
            <span v-if="completedAt[lesson.id]" class="shrink-0 text-xs text-pewter">
              {{ formatDate(completedAt[lesson.id]) }}
            </span>
          </NuxtLink>
        </li>
      </ol>
    </section>
  </div>
</template>
```

- [ ] **Step 7: `ResumeButton` schreiben**

`app/components/ResumeButton.vue`:

```vue
<script setup>
const props = defineProps({
  lessons: { type: Array, required: true }
})

const { completedIds } = useProgress()
const { lastLessonId } = useProfile()

const target = computed(() => resumeTarget(props.lessons, completedIds.value, lastLessonId.value))
</script>

<template>
  <NuxtLink v-if="target.state === 'start'" :to="`/kurs/${target.lesson.slug}`" class="btn-primary">
    Kurs starten
  </NuxtLink>
  <NuxtLink v-else-if="target.state === 'continue'" :to="`/kurs/${target.lesson.slug}`" class="btn-primary">
    Kurs weitermachen
  </NuxtLink>
  <p v-else-if="target.state === 'done'" class="text-sm">
    <span class="font-semibold text-ink">Kurs abgeschlossen.</span>
    <NuxtLink :to="`/kurs/${target.lesson.slug}`" class="text-link ml-2">Zur letzten Lektion</NuxtLink>
  </p>
</template>
```

- [ ] **Step 8: Startseite ersetzen**

`app/pages/index.vue`:

```vue
<script setup>
const user = useSupabaseUser()
const { data: lessons, error } = await useLessons()
const { completedIds } = useProgress()

const percent = computed(() => percentComplete(lessons.value, completedIds.value))

useSeoMeta({
  title: 'Programmieren lernen mit Nuxt',
  description: 'Ein kostenloser Schnupperkurs: Bau Schritt für Schritt deine erste Todo-App mit HTML, CSS und JavaScript.'
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h1 class="max-w-3xl text-5xl font-medium leading-none tracking-[-0.025em] text-ink sm:text-7xl sm:tracking-[-0.03em]">
        Deine erste Web-App. Schritt für Schritt.
      </h1>
      <p class="mt-6 max-w-[640px] text-xl">
        In diesem kostenlosen Kurs baust du auf deinem eigenen Rechner eine Todo-App mit Nuxt.
        Du brauchst keine Vorkenntnisse, nur etwas Neugier.
      </p>
      <div class="mt-8 flex flex-wrap items-center gap-6">
        <ResumeButton :lessons="lessons" />
        <NuxtLink v-if="!user" to="/registrieren" class="btn-ghost">
          Konto erstellen und Fortschritt speichern
        </NuxtLink>
      </div>
      <ProgressBar v-if="user" class="mt-8 max-w-md" :percent="percent" label="Dein Fortschritt" />
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-4xl font-medium tracking-[-0.02em] text-ink">Die Lektionen</h2>
        <p v-if="error" class="notice mt-8 max-w-[640px] bg-paper" role="alert">
          Die Lektionen konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="lessons.length === 0" class="mt-8">Die ersten Lektionen erscheinen bald.</p>
        <LessonList
          v-else
          class="mt-8 max-w-3xl"
          :lessons="lessons"
          :completed-ids="completedIds"
          :show-counts="Boolean(user)"
          show-summary
        />
      </div>
    </section>
  </div>
</template>
```

- [ ] **Step 9: Bauen und prüfen**

Run: `yarn test`
Expected: PASS, 32 Tests.

Run: `yarn build`
Expected: Build endet ohne Fehler.

Mit laufendem `yarn dev`:

```powershell
$html = curl.exe -s http://localhost:3000/; $html -match 'Die erste Seite'; $html -match 'JavaScript'; $html -match 'Kurs starten'; $html -match 'Diese Lektion ist nicht veröffentlicht'
```

Expected: `True`, `True`, `True`, `False`. Die unveröffentlichte Lektion `entwurf` erscheint nicht.

Im Browser prüfen: Die Liste zeigt fünf Blöcke in der Reihenfolge Start, HTML, CSS, JavaScript, Abschluss, jeweils mit Etikett; die Lektionen stehen in weißen Karten auf grauem Grund.

- [ ] **Step 10: Commit**

```powershell
git add app/composables app/components app/pages/index.vue
git commit -m "Add data composables, lesson list and landing page"
```

---

### Task 7: Lektionsseite

**Files:**
- Create: `app/components/mdc/ProsePre.vue`, `app/components/LessonContent.vue`, `app/components/LessonSolution.vue`, `app/components/CompleteButton.vue`
- Create: `app/pages/kurs/[slug].vue`

**Interfaces:**
- Consumes: `useLesson`, `useLessons`, `useProgress`, `useProfile`, `LessonList`, `SectionTag` aus Task 6; CSS-Klassen `lesson-prose`, `code-block`, `code-block-bar` aus Task 4
- Produces:
  - `<LessonContent :value="markdown">`
  - `<LessonSolution :value="markdown">`
  - `<CompleteButton :lesson-id="number">`
  - Seite `/kurs/<slug>`

`@nuxtjs/mdc` registriert Komponenten aus `app/components/mdc/` global und nimmt `ProsePre` von dort statt der eingebauten Fassung.

- [ ] **Step 1: Codeblock mit Kopier-Button schreiben**

`app/components/mdc/ProsePre.vue`:

```vue
<script setup>
const props = defineProps({
  code: { type: String, default: '' },
  language: { type: String, default: null },
  filename: { type: String, default: null },
  highlights: { type: Array, default: () => [] },
  meta: { type: String, default: null },
  class: { type: String, default: null }
})

const copied = ref(false)

async function copy() {
  try {
    await navigator.clipboard.writeText(props.code)
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  } catch {
    copied.value = false
  }
}
</script>

<template>
  <div class="code-block">
    <div class="code-block-bar">
      <span>{{ filename || language || 'Code' }}</span>
      <button type="button" class="font-medium text-ink hover:underline" @click="copy">
        {{ copied ? 'Kopiert' : 'Kopieren' }}
      </button>
    </div>
    <pre :class="$props.class"><slot /></pre>
  </div>
</template>
```

- [ ] **Step 2: `LessonContent` schreiben**

`app/components/LessonContent.vue`:

```vue
<script setup>
defineProps({
  value: { type: String, required: true }
})
</script>

<template>
  <div class="lesson-prose">
    <MDC :value="value" tag="div" />
  </div>
</template>
```

- [ ] **Step 3: `LessonSolution` schreiben**

`app/components/LessonSolution.vue`:

```vue
<script setup>
defineProps({
  value: { type: String, required: true }
})
</script>

<template>
  <details class="mt-12 max-w-[640px] rounded-xl border border-mist/60">
    <summary class="cursor-pointer px-6 py-4 font-medium text-ink">Musterlösung anzeigen</summary>
    <div class="border-t border-mist/60 px-6 py-2">
      <LessonContent :value="value" />
    </div>
  </details>
</template>
```

- [ ] **Step 4: `CompleteButton` schreiben**

`app/components/CompleteButton.vue`:

```vue
<script setup>
const props = defineProps({
  lessonId: { type: Number, required: true }
})

const user = useSupabaseUser()
const route = useRoute()
const { completedIds, complete, uncomplete } = useProgress()

const pending = ref(false)
const failed = ref(false)
const done = computed(() => completedIds.value.has(props.lessonId))

async function toggle() {
  // Schützt vor Doppelklicks, solange die erste Anfrage läuft.
  if (pending.value) return
  pending.value = true
  failed.value = false
  const ok = done.value ? await uncomplete(props.lessonId) : await complete(props.lessonId)
  failed.value = !ok
  pending.value = false
}
</script>

<template>
  <div>
    <template v-if="user">
      <button
        type="button"
        :class="done ? 'btn-secondary' : 'btn-primary'"
        :disabled="pending"
        :aria-pressed="done"
        @click="toggle"
      >
        {{ done ? '✓ Erledigt – zurücknehmen' : 'Lektion abschließen' }}
      </button>
      <p v-if="failed" class="notice mt-4 max-w-[640px]" role="alert">
        Das Speichern hat nicht geklappt. Prüf deine Internetverbindung und versuch es noch einmal.
      </p>
    </template>
    <p v-else class="notice max-w-[640px]">
      <NuxtLink :to="{ path: '/login', query: { weiter: route.fullPath } }" class="text-link">Melde dich an</NuxtLink>,
      um diese Lektion als erledigt zu markieren und deinen Fortschritt zu speichern.
    </p>
  </div>
</template>
```

- [ ] **Step 5: Lektionsseite schreiben**

`app/pages/kurs/[slug].vue`:

```vue
<script setup>
const route = useRoute()
const user = useSupabaseUser()

const { data: lesson, error } = await useLesson(route.params.slug)
if (error.value) {
  throw createError({
    statusCode: error.value.statusCode ?? 500,
    statusMessage: error.value.statusMessage ?? 'Die Lektion konnte nicht geladen werden.',
    fatal: true
  })
}

const { data: lessons } = await useLessons()
const { completedIds } = useProgress()
const { saveLastLesson } = useProfile()

const index = computed(() => lessons.value.findIndex(item => item.id === lesson.value.id))
const previous = computed(() => (index.value > 0 ? lessons.value[index.value - 1] : null))
const next = computed(() => (index.value >= 0 && index.value < lessons.value.length - 1 ? lessons.value[index.value + 1] : null))

// Merkt sich die zuletzt geöffnete Lektion, auch wenn man sich erst auf dieser Seite anmeldet.
watch(() => user.value?.sub, (userId) => {
  if (userId && import.meta.client) saveLastLesson(lesson.value.id)
}, { immediate: true })

useSeoMeta({
  title: () => lesson.value.title,
  description: () => lesson.value.summary
})
</script>

<template>
  <div class="mx-auto grid max-w-[1200px] gap-8 px-4 py-8 sm:px-6 lg:grid-cols-[280px_minmax(0,1fr)] lg:gap-12 lg:py-12">
    <aside>
      <details class="rounded-xl border border-mist/60 lg:hidden">
        <summary class="cursor-pointer px-4 py-3 text-sm font-medium text-ink">Alle Lektionen</summary>
        <div class="border-t border-mist/60 p-4">
          <LessonList :lessons="lessons" :completed-ids="completedIds" :current-slug="lesson.slug" />
        </div>
      </details>
      <nav class="sticky top-8 hidden lg:block" aria-label="Lektionen">
        <LessonList :lessons="lessons" :completed-ids="completedIds" :current-slug="lesson.slug" />
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
        <NuxtLink v-if="previous" :to="`/kurs/${previous.slug}`" class="btn-ghost">← {{ previous.title }}</NuxtLink>
        <span v-else />
        <NuxtLink v-if="next" :to="`/kurs/${next.slug}`" class="btn-ghost text-right">{{ next.title }} →</NuxtLink>
      </nav>
    </article>
  </div>
</template>
```

- [ ] **Step 6: Bauen und ausgeloggt prüfen**

Run: `yarn build`
Expected: Build endet ohne Fehler.

Mit laufendem `yarn dev`:

```powershell
$html = curl.exe -s http://localhost:3000/kurs/die-erste-seite; $html -match 'Das Template'; $html -match 'Musterlösung anzeigen'; $html -match 'Melde dich an'; $html -match 'shiki'; curl.exe -s -o NUL -w "%{http_code}`n" http://localhost:3000/kurs/entwurf; curl.exe -s -o NUL -w "%{http_code}`n" http://localhost:3000/kurs/gibt-es-nicht
```

Expected: `True`, `True`, `True`, `True`, `404`, `404`.

Im Browser `/kurs/die-erste-seite` prüfen:

1. Der Codeblock ist farbig, steht auf grauem Grund, zeigt `app/app.vue` in der Leiste, und „Kopieren“ legt den Code in die Zwischenablage.
2. „Musterlösung anzeigen“ klappt auf.
3. `/kurs/willkommen` zeigt keine Musterlösung und kein „Zurück“; der Link im Text ist schwarz und unterstrichen.
4. Bei 375px Breite gibt es kein horizontales Scrollen der Seite; die Lektionsliste liegt hinter „Alle Lektionen“.

- [ ] **Step 7: Fortschritt eingeloggt prüfen**

Voraussetzung: ein bestätigtes Konto. Falls noch keines existiert, zuerst die Schritte 1 bis 3 aus Task 9 Step 4 ausführen.

Eingeloggt im Browser:

1. `/kurs/die-erste-seite` öffnen, „Lektion abschließen“ klicken. Expected: Button wechselt zu „✓ Erledigt – zurücknehmen“, in der Seitenleiste erscheint ein oranges Häkchen.
2. Seite neu laden. Expected: Zustand bleibt erhalten.
3. „✓ Erledigt – zurücknehmen“ klicken, neu laden. Expected: wieder „Lektion abschließen“.
4. Sehr schnell doppelt auf „Lektion abschließen“ klicken. Expected: keine Fehlermeldung. Danach per `mcp__supabase__execute_sql` prüfen:

```sql
select lesson_id, count(*) from public.lesson_progress group by lesson_id;
```

Expected: genau eine Zeile für die Lektion, `count = 1`.

5. In den Entwicklerwerkzeugen das Netzwerk auf „Offline“ stellen und den Button klicken. Expected: Der Button springt in den vorherigen Zustand zurück und der Hinweis „Das Speichern hat nicht geklappt …“ erscheint.

- [ ] **Step 8: Commit**

```powershell
git add app/components app/pages/kurs
git commit -m "Add lesson page with rendered markdown, solution and completion"
```

---

### Task 8: Profilseite

**Files:**
- Create: `app/components/PasswordForm.vue`, `app/pages/profil.vue`

**Interfaces:**
- Consumes: Middleware `auth` aus Task 5; `useLessons`, `useProgress`, `LessonList`, `ProgressBar`, `ResumeButton` aus Task 6; `authErrorMessage` aus Task 2
- Produces: Seite `/profil`

- [ ] **Step 1: `PasswordForm` schreiben**

`app/components/PasswordForm.vue`:

```vue
<script setup>
const client = useSupabaseClient()

const password = ref('')
const repeat = ref('')
const pending = ref(false)
const error = ref('')
const saved = ref(false)

async function save() {
  error.value = ''
  saved.value = false
  if (password.value !== repeat.value) {
    error.value = 'Die beiden Passwörter stimmen nicht überein.'
    return
  }
  pending.value = true
  const { error: authError } = await client.auth.updateUser({ password: password.value })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
    return
  }
  password.value = ''
  repeat.value = ''
  saved.value = true
}
</script>

<template>
  <form class="max-w-md space-y-4" @submit.prevent="save">
    <div>
      <label class="field-label" for="new-password">Neues Passwort</label>
      <input id="new-password" v-model="password" class="input" type="password" autocomplete="new-password" minlength="8" required>
    </div>
    <div>
      <label class="field-label" for="repeat-password">Neues Passwort wiederholen</label>
      <input id="repeat-password" v-model="repeat" class="input" type="password" autocomplete="new-password" minlength="8" required>
    </div>
    <p v-if="error" class="notice" role="alert">{{ error }}</p>
    <p v-if="saved" class="notice" role="status">Dein Passwort ist geändert.</p>
    <button type="submit" class="btn-secondary" :disabled="pending">
      {{ pending ? 'Einen Moment …' : 'Passwort ändern' }}
    </button>
  </form>
</template>
```

- [ ] **Step 2: Profilseite schreiben**

`app/pages/profil.vue`:

```vue
<script setup>
definePageMeta({ middleware: 'auth' })

const client = useSupabaseClient()
const user = useSupabaseUser()
const { data: lessons, error } = await useLessons()
const { completedIds, completedAt } = useProgress()

const percent = computed(() => percentComplete(lessons.value, completedIds.value))
const counts = computed(() => countCompleted(lessons.value, completedIds.value))

async function logout() {
  await client.auth.signOut()
  user.value = null
  await navigateTo('/')
}

useSeoMeta({ title: 'Profil' })
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <p class="text-sm font-medium text-pewter">Dein Profil</p>
      <h1 class="mt-2 break-words text-4xl font-medium tracking-[-0.02em] text-ink">{{ user?.email }}</h1>

      <ProgressBar class="mt-10 max-w-md" :percent="percent" label="Dein Fortschritt" />
      <p class="mt-2 text-sm">{{ counts.done }} von {{ counts.total }} Lektionen erledigt</p>

      <div class="mt-8">
        <ResumeButton :lessons="lessons" />
      </div>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-2xl font-medium text-ink">Deine Lektionen</h2>
        <p v-if="error" class="notice mt-8 max-w-[640px] bg-paper" role="alert">
          Die Lektionen konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <LessonList
          v-else
          class="mt-8 max-w-3xl"
          :lessons="lessons"
          :completed-ids="completedIds"
          :completed-at="completedAt"
          show-counts
        />
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

- [ ] **Step 3: Bauen und ausgeloggt prüfen**

Run: `yarn build`
Expected: Build endet ohne Fehler.

Mit laufendem `yarn dev`:

```powershell
curl.exe -s -o NUL -w "%{http_code} %{redirect_url}`n" http://localhost:3000/profil
```

Expected: Status `302` und eine Adresse, die mit `http://localhost:3000/login?weiter=` beginnt und auf `profil` endet.

- [ ] **Step 4: Eingeloggt prüfen**

Eingeloggt im Browser:

1. `/profil` zeigt die eigene E-Mail-Adresse, den Fortschrittsbalken, „x von 5 Lektionen erledigt“ und je Block „x von y erledigt“.
2. Eine Lektion abschließen, zurück zum Profil. Expected: Häkchen und das heutige Datum stehen an der Lektion, der Prozentwert ist gestiegen.
3. `/kurs/tailwind-einrichten` öffnen, ohne sie abzuschließen, dann `/profil` öffnen und „Kurs weitermachen“ klicken. Expected: Es öffnet sich `/kurs/tailwind-einrichten`.
4. Diese Lektion abschließen, dann im Profil „Kurs weitermachen“ klicken. Expected: Es öffnet sich die erste noch offene Lektion in Kursreihenfolge.
5. Alle fünf Lektionen abschließen. Expected: Statt des Buttons steht „Kurs abgeschlossen.“ mit Link „Zur letzten Lektion“; der Balken zeigt 100 %.
6. Im Passwortformular zwei verschiedene Passwörter eingeben. Expected: „Die beiden Passwörter stimmen nicht überein.“
7. „Abmelden“ klicken. Expected: Startseite, Kopfzeile zeigt „Anmelden“ und „Konto erstellen“.

- [ ] **Step 5: Commit**

```powershell
git add app/components/PasswordForm.vue app/pages/profil.vue
git commit -m "Add profile page with progress, resume and password change"
```

---

### Task 9: Abnahme

**Files:**
- Keine neuen Dateien. Fehler, die hier auffallen, werden in der betroffenen Datei behoben und einzeln committet.

**Interfaces:**
- Consumes: alles aus Task 1 bis 8

- [ ] **Step 1: Tests und Build**

Run: `yarn test`
Expected: PASS, 32 Tests.

Run: `yarn build`
Expected: Build endet ohne Fehler und ohne Warnungen aus `app/`.

- [ ] **Step 2: Zugriffsregeln erneut prüfen**

Den Inhalt von `supabase/tests/rls.sql` mit `mcp__supabase__execute_sql` ausführen.
Expected: `rls ok`.

`mcp__supabase__get_advisors` mit Typ `security` aufrufen.
Expected: Keine Hinweise zu den drei Tabellen.

- [ ] **Step 3: Gestaltungsregeln im Code prüfen**

```powershell
Get-ChildItem app -Recurse -Include *.vue, *.css | Select-String -Pattern 'shadow|text-red|bg-red|text-green|bg-green|text-blue|bg-blue|rounded-lg|rounded-2xl|rounded-sm' | ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
```

Expected: keine Treffer.

- [ ] **Step 4: Abläufe mit echten Mails durchspielen**

Der eingebaute Mailversand von Supabase stellt nur an Adressen von Mitgliedern der Supabase-Organisation zu und erlaubt wenige Mails pro Stunde. Diese Prüfung macht deshalb der Projektinhaber mit der eigenen Adresse; Registrierung und Reset brauchen zusammen zwei Mails.

1. `/registrieren` mit eigener Adresse und Passwort absenden. Expected: „Fast geschafft: Wir haben dir eine Mail geschickt …“
2. Den Link in der Mail im selben Browser öffnen. Expected: kurz „Dein Konto wird bestätigt …“, dann das Profil.
3. Abmelden, mit denselben Daten auf `/login` anmelden. Expected: Profil.
4. Noch einmal `/registrieren` mit derselben Adresse absenden. Expected: „Mit dieser E-Mail-Adresse gibt es bereits ein Konto …“, keine Mail.
5. Ausgeloggt `/kurs/daten-anzeigen` öffnen, auf „Melde dich an“ klicken, anmelden. Expected: Rückkehr zu `/kurs/daten-anzeigen`.
6. Abmelden, `/passwort-vergessen` mit der eigenen Adresse absenden, den Link aus der Mail im selben Browser öffnen, neues Passwort setzen. Expected: Profil; die Anmeldung mit dem neuen Passwort funktioniert, mit dem alten nicht.
7. Den Reset-Link ein zweites Mal öffnen. Expected: „Der Link funktioniert nicht mehr“.

- [ ] **Step 5: Abschluss-Commit, falls Korrekturen offen sind**

```powershell
git status --short
```

Expected: leere Ausgabe. Andernfalls die Korrekturen committen.
