# Kursinhalte „Erste Schritte“ und „Todo-App“: Umsetzungsplan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Die beiden Kurse „Erste Schritte“ (3 Lektionen) und „Todo-App“ (16 Lektionen) schreiben, technisch prüfen und in Supabase einspielen.

**Architecture:** Die Lektionen werden als Markdown-Dateien unter `kursinhalt/` geschrieben. Ein kleines Node-Skript erzeugt daraus `supabase/seeds/courses.sql`; ein zweites spielt die Musterlösungen der Todo-App der Reihe nach in ein frisches Nuxt-Projekt außerhalb des Repos ein und baut jeden Zwischenstand. Nach dem einmaligen Einspielen ist die Datenbank die maßgebliche Quelle.

**Tech Stack:** Node.js (ES-Module, keine zusätzlichen Pakete), Vitest, Supabase CLI. Im Kursprojekt der Lernenden: Nuxt 4, Tailwind 4 mit `@tailwindcss/vite`, `@lucide/vue`.

**Spec:** `docs/superpowers/specs/2026-10-06-mehrere-kurse-design.md`, Abschnitt „Kursinhalt“

## Global Constraints

- Lektionstexte sind deutsch, duzen und richten sich an Menschen ohne Programmiererfahrung.
- Code der Todo-App: HTML im Template, JavaScript mit `<script setup>`, kein TypeScript, Tailwind fürs Styling, Icons aus `@lucide/vue`, Aufgaben im `localStorage`.
- Im Code heißt es durchgehend `tasks`, `newTask`, `addTask`, `checkTask`, `deleteTask`, `clearTasks`, `openCount` und `TaskItem`. Sichtbare Texte der App sind deutsch.
- Jede Lektion mit Code hat drei Teile in dieser Reihenfolge: Erklärung an einem kleinen Beispiel, Abschnitt `## Deine Aufgabe`, Musterlösung. Der Lektionstext verrät den Code der Aufgabe nicht.
- Eine Musterlösung zeigt jede in der Lektion geänderte oder neu angelegte Datei vollständig, als Codeblock mit Dateipfad in eckigen Klammern, zum Beispiel ```` ```vue [app/app.vue] ````.
- `{{ }}` und Attribute, die mit `:` oder `@` beginnen, stehen im Fließtext immer in Code-Auszeichnung (Backticks). Kein Wort im Fließtext beginnt mit einem Doppelpunkt.
- Blöcke: `start`, `html`, `css`, `js`, `abschluss`.
- Kurse und Adressteile wie in der Spec: `erste-schritte` (Position 1), `todo-app` (Position 2, empfiehlt `erste-schritte`).
- Tatsachen über Werkzeuge (Befehle, Abfragen von `npm create nuxt`, Paketnamen, Icon-Namen) werden durch Ausführen geprüft, nicht aus dem Gedächtnis geschrieben. Was sich nicht prüfen lässt (Installationsfenster von Node.js und VS Code), wird allgemein beschrieben und auf die offizielle Seite verwiesen.
- Paketmanager des Repos ist yarn 1.x; im Kurs benutzen die Lernenden `npm`.
- Shell ist PowerShell 5.1 unter Windows (kein `&&`). Terminalbefehle im Kurs funktionieren unter Windows und macOS gleich; wo sie sich unterscheiden, stehen beide Varianten da.
- Supabase: Projekt-Ref `vsoqzbtusinpkeabygxg`; SQL läuft mit `supabase db query --linked`, nicht über das MCP-Tool `execute_sql`. Die CLI liest `.env` nicht selbst:

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase migration list
```

- Auf Port 3000 läuft möglicherweise der Entwicklungsserver des Projektinhabers. Er wird nicht beendet und nicht neu gestartet; `yarn build` im Repo entfällt, solange er läuft. Das Prüfprojekt der Todo-App liegt außerhalb des Repos und benutzt einen anderen Port.
- Der Arbeitszweig ist `mehrere-kurse`.

## Review Focus

1. Eine Lektion enthält `{{ … }}` oder `:class` außerhalb von Code: Der Renderer der Kursseite würde daraus einen Befehl machen. Das Erzeugungsskript bricht mit Dateiname und Zeile ab. Test in Task 1.
2. Eine Musterlösung lässt eine geänderte Datei weg oder zeigt nur einen Ausschnitt: Der nächste Zwischenstand baut nicht oder weicht vom Text ab. Das Prüfskript baut jeden Zwischenstand. Prüfung in Task 3 und 4.
3. Der Stand nach der letzten Lektion weicht von der fertigen App in diesem Plan ab: Lektion 16 zeigt dann anderen Code, als die Lernenden haben. Vergleich in Task 4.
4. Das Einspielen trifft auf die Beispielkurse mit denselben Adressteilen: Alte Beispiel-Lektionen bleiben stehen oder neue werden übersprungen. Prüfung in Task 5.
5. Ein Lektionstext enthält die Zeichenfolge, mit der das SQL den Text einfasst: Das SQL bricht oder wird falsch gelesen. Das Erzeugungsskript bricht ab. Test in Task 1.

## Format der Lektionsdateien

```
kursinhalt/
  erste-schritte/
    kurs.json
    01-willkommen.md
    …
  todo-app/
    kurs.json
    01-was-wir-bauen.md
    …
```

`kurs.json`:

```json
{
  "slug": "todo-app",
  "title": "Todo-App",
  "summary": "Bau Schritt für Schritt deine erste eigene Web-App: eine Aufgabenliste mit Nuxt.",
  "position": 2,
  "recommended": "erste-schritte"
}
```

`recommended` darf fehlen. Eine Lektionsdatei heißt `NN-<slug>.md`; `NN` ist die Position, `<slug>` der Adressteil:

```markdown
---
title: Die erste Seite
summary: Du schreibst dein erstes HTML und siehst es sofort im Browser.
section: html
---

## Erklärung …

## Deine Aufgabe

…

<!-- loesung -->

```vue [app/app.vue]
<template>
  …
</template>
```
```

Alles nach der Zeile `<!-- loesung -->` ist die Musterlösung. Fehlt die Zeile, hat die Lektion keine Musterlösung.

## Die fertige Todo-App

Der Stand nach Lektion 15 muss diesen vier Dateien entsprechen. Abweichungen in Klassen sind erlaubt, wenn sie in Task 3 begründet und in Lektion 16 übernommen werden; Namen, Struktur und Verhalten sind fest.

`nuxt.config.ts`:

```ts
import tailwindcss from '@tailwindcss/vite'

export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],
  vite: {
    plugins: [tailwindcss()]
  }
})
```

`app/assets/css/main.css`:

```css
@import "tailwindcss";
```

`app/app.vue`:

```vue
<script setup>
import { ListTodo, Plus, Trash2 } from '@lucide/vue'

const tasks = ref([])
const newTask = ref('')

const openCount = computed(() => tasks.value.filter(task => !task.done).length)

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}

function checkTask(id) {
  const task = tasks.value.find(task => task.id === id)
  task.done = !task.done
}

function deleteTask(id) {
  tasks.value = tasks.value.filter(task => task.id !== id)
}

function clearTasks() {
  tasks.value = []
}

onMounted(() => {
  const saved = localStorage.getItem('tasks')
  if (saved) tasks.value = JSON.parse(saved)
})

watch(tasks, () => {
  localStorage.setItem('tasks', JSON.stringify(tasks.value))
}, { deep: true })
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">{{ openCount }} offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
          type="text"
          placeholder="Neue Aufgabe"
          aria-label="Neue Aufgabe"
          class="min-w-0 flex-1 rounded-xl border border-slate-300 px-4 py-2 text-slate-900 placeholder:text-slate-400 focus:border-indigo-600 focus:outline-none"
        >
        <button
          type="submit"
          aria-label="Aufgabe hinzufügen"
          class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-indigo-600 text-white transition-colors hover:bg-indigo-700 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          <Plus class="size-5" />
        </button>
      </form>

      <p v-if="tasks.length === 0" class="mt-6 text-center text-slate-500">
        Noch keine Aufgaben. Leg los!
      </p>
      <ul v-else class="mt-6 space-y-2">
        <TaskItem
          v-for="task in tasks"
          :key="task.id"
          :task="task"
          @check="checkTask"
          @delete="deleteTask"
        />
      </ul>

      <button
        v-if="tasks.length > 0"
        type="button"
        class="mt-6 flex items-center gap-2 text-sm text-slate-500 transition-colors hover:text-red-600"
        @click="clearTasks"
      >
        <Trash2 class="size-4" />
        Alle löschen
      </button>
    </div>
  </main>
</template>
```

`app/components/TaskItem.vue`:

```vue
<script setup>
import { Check, Trash2 } from '@lucide/vue'

defineProps({
  task: { type: Object, required: true }
})

defineEmits(['check', 'delete'])
</script>

<template>
  <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
    <button
      type="button"
      :aria-label="task.done ? 'Als offen markieren' : 'Als erledigt markieren'"
      class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      :class="task.done ? 'border-indigo-600 bg-indigo-600 text-white' : 'border-slate-300 text-transparent hover:border-indigo-600'"
      @click="$emit('check', task.id)"
    >
      <Check class="size-4" />
    </button>
    <span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
      {{ task.title }}
    </span>
    <button
      type="button"
      aria-label="Aufgabe löschen"
      class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      @click="$emit('delete', task.id)"
    >
      <Trash2 class="size-4" />
    </button>
  </li>
</template>
```

## Schreibregeln für Lektionen

- Länge: 250 bis 600 Wörter Fließtext je Lektion, ohne Code.
- Kurze Absätze, ein Gedanke je Absatz. Jeder neue Fachbegriff wird beim ersten Auftreten in einem Satz erklärt und fett gesetzt.
- Jeder Befehl und jeder Code steht in einem Codeblock mit Sprache; bei Dateien mit Pfad in eckigen Klammern.
- Nach jedem Schritt steht, was man jetzt sehen sollte.
- Vor „Deine Aufgabe“ steht höchstens ein kleines Beispiel, das das Neue zeigt, aber nicht die Lösung der Aufgabe ist.
- „Deine Aufgabe“ nennt das Ziel in ein bis drei Sätzen und gibt, wenn nötig, einen Tipp, aber keinen fertigen Code.
- Jede Lektion mit Code hat am Ende des Textes einen Abschnitt `### Wenn es nicht klappt` mit zwei bis vier typischen Fehlern und ihrer Ursache.
- Überschriften beginnen bei `##`. Der Lektionstitel steht nicht noch einmal im Text.
- Keine Emojis, keine Ausrufezeichen-Ketten, keine englischen Füllwörter.

---

### Task 1: Werkzeuge für die Kursinhalte

**Files:**
- Create: `scripts/course-content.mjs`, `scripts/build-seed.mjs`, `scripts/verify-course.mjs`
- Create: `kursinhalt/README.md`
- Test: `tests/unit/courseContent.test.js`
- Modify: `package.json` (zwei Skripte)

**Interfaces:**
- Produces:
  - `parseLesson(fileName: string, text: string): { position: number, slug: string, title: string, summary: string, section: string, content: string, solution: string | null }`; wirft einen `Error` mit Dateiname (und Zeile, wo sinnvoll) bei: Dateiname nicht `NN-slug.md`, fehlendem Kopf, fehlendem `title`, `summary` oder `section`, unbekanntem `section`, leerem Inhalt, `{{` außerhalb von Code, Wort mit führendem `:` außerhalb von Code, Vorkommen von `$lesson$`
  - `extractFiles(markdown: string): { path: string, code: string }[]`: alle Codeblöcke mit `[pfad]` in der Reihenfolge ihres Auftretens
  - `buildSeedSql(courses: { slug, title, summary, position, recommended?, lessons: Lesson[] }[]): string`
  - `yarn content:seed` schreibt `supabase/seeds/courses.sql`
  - `yarn content:verify <kurs-slug>` baut jeden Zwischenstand eines Kurses in einem Prüfprojekt außerhalb des Repos

- [ ] **Step 1: Tests schreiben**

`tests/unit/courseContent.test.js`:

```js
import { describe, expect, it } from 'vitest'
import { buildSeedSql, extractFiles, parseLesson } from '../../scripts/course-content.mjs'

const head = '---\ntitle: Die erste Seite\nsummary: Dein erstes HTML.\nsection: html\n---\n'

describe('parseLesson', () => {
  it('liest Position und Adressteil aus dem Dateinamen und die Angaben aus dem Kopf', () => {
    const lesson = parseLesson('03-die-erste-seite.md', `${head}\n## Start\n\nText.\n`)
    expect(lesson).toMatchObject({
      position: 3,
      slug: 'die-erste-seite',
      title: 'Die erste Seite',
      summary: 'Dein erstes HTML.',
      section: 'html',
      solution: null
    })
    expect(lesson.content).toBe('## Start\n\nText.')
  })

  it('trennt die Musterlösung am Marker ab', () => {
    const lesson = parseLesson('03-die-erste-seite.md', `${head}\nText.\n\n<!-- loesung -->\n\n\`\`\`vue [app/app.vue]\n<template />\n\`\`\`\n`)
    expect(lesson.content).toBe('Text.')
    expect(lesson.solution).toBe('```vue [app/app.vue]\n<template />\n```')
  })

  it('kommt mit Windows-Zeilenenden zurecht', () => {
    const lesson = parseLesson('01-start.md', `${head}\nText.\n`.replaceAll('\n', '\r\n'))
    expect(lesson.title).toBe('Die erste Seite')
    expect(lesson.content).toBe('Text.')
  })

  it('lehnt einen falschen Dateinamen ab', () => {
    expect(() => parseLesson('erste-seite.md', `${head}\nText.\n`)).toThrow(/erste-seite\.md/)
  })

  it('lehnt einen fehlenden Kopf und fehlende Angaben ab', () => {
    expect(() => parseLesson('01-a.md', 'Text.')).toThrow(/01-a\.md/)
    expect(() => parseLesson('01-a.md', '---\ntitle: A\nsection: html\n---\n\nText.\n')).toThrow(/summary/)
  })

  it('lehnt einen unbekannten Block ab', () => {
    expect(() => parseLesson('01-a.md', '---\ntitle: A\nsummary: B\nsection: bonus\n---\n\nText.\n')).toThrow(/bonus/)
  })

  it('lehnt eine Lektion ohne Text ab', () => {
    expect(() => parseLesson('01-a.md', `${head}\n\n`)).toThrow(/01-a\.md/)
  })

  it('lehnt doppelte geschweifte Klammern außerhalb von Code ab und nennt die Zeile', () => {
    const text = `${head}\nZeile eins.\n\nMit {{ name }} gibst du etwas aus.\n`
    expect(() => parseLesson('01-a.md', text)).toThrow(/01-a\.md:8/)
  })

  it('erlaubt doppelte geschweifte Klammern in Inline-Code und in Codeblöcken', () => {
    const text = `${head}\nMit \`{{ name }}\` gibst du etwas aus.\n\n\`\`\`vue\n<p>{{ name }}</p>\n\`\`\`\n`
    expect(() => parseLesson('01-a.md', text)).not.toThrow()
  })

  it('lehnt ein Wort mit führendem Doppelpunkt außerhalb von Code ab', () => {
    expect(() => parseLesson('01-a.md', `${head}\nNutze :class für Klassen.\n`)).toThrow(/01-a\.md:6/)
  })

  it('erlaubt Doppelpunkte am Wortende, in Uhrzeiten und in Adressen', () => {
    const text = `${head}\nMerke: Um 10:30 öffnest du http://localhost:3000 im Browser.\n`
    expect(() => parseLesson('01-a.md', text)).not.toThrow()
  })

  it('prüft auch die Musterlösung', () => {
    const text = `${head}\nText.\n\n<!-- loesung -->\n\nHier steht {{ falsch }}.\n`
    expect(() => parseLesson('01-a.md', text)).toThrow(/01-a\.md:10/)
  })

  it('lehnt die Einfassung des SQL-Texts im Inhalt ab', () => {
    expect(() => parseLesson('01-a.md', `${head}\nText mit $lesson$ darin.\n`)).toThrow(/\$lesson\$/)
  })
})

describe('extractFiles', () => {
  it('liefert Pfad und Code aller Codeblöcke mit Dateipfad in Reihenfolge', () => {
    const markdown = '```vue [app/app.vue]\n<template />\n```\n\nText\n\n```css [app/assets/css/main.css]\n@import "tailwindcss";\n```\n'
    expect(extractFiles(markdown)).toEqual([
      { path: 'app/app.vue', code: '<template />\n' },
      { path: 'app/assets/css/main.css', code: '@import "tailwindcss";\n' }
    ])
  })

  it('überspringt Codeblöcke ohne Dateipfad', () => {
    expect(extractFiles('```bash\nnpm run dev\n```\n')).toEqual([])
  })

  it('lehnt Pfade ab, die aus dem Projekt herausführen', () => {
    expect(() => extractFiles('```js [../boese.js]\nx\n```\n')).toThrow(/\.\.\/boese\.js/)
    expect(() => extractFiles('```js [/etc/passwd]\nx\n```\n')).toThrow(/\/etc\/passwd/)
  })
})

describe('buildSeedSql', () => {
  const courses = [
    {
      slug: 'erste-schritte', title: 'Erste Schritte', summary: 'Einstieg.', position: 1,
      lessons: [{ position: 1, slug: 'willkommen', title: "Los geht's", summary: 'Start.', section: 'start', content: 'Hallo.', solution: null }]
    },
    {
      slug: 'todo-app', title: 'Todo-App', summary: 'Die App.', position: 2, recommended: 'erste-schritte',
      lessons: [{ position: 1, slug: 'seite', title: 'Seite', summary: 'HTML.', section: 'html', content: 'Text.', solution: 'Code.' }]
    }
  ]

  it('schreibt Kurse und Lektionen als Upsert und veröffentlicht sie', () => {
    const sql = buildSeedSql(courses)
    expect(sql).toContain("('erste-schritte', 'Erste Schritte', 'Einstieg.', 1, true)")
    expect(sql).toContain('on conflict (slug) do update')
    expect(sql).toContain('on conflict (course_id, slug) do update')
    expect(sql).toContain('$lesson$Hallo.$lesson$')
  })

  it('verdoppelt einfache Anführungszeichen in Titeln', () => {
    expect(buildSeedSql(courses)).toContain("'Los geht''s'")
  })

  it('setzt den empfohlenen Kurs und schreibt null für eine fehlende Musterlösung', () => {
    const sql = buildSeedSql(courses)
    expect(sql).toMatch(/set recommended_course_id = \(select id from public\.courses where slug = 'erste-schritte'\)\s+where slug = 'todo-app'/)
    expect(sql).toMatch(/\$lesson\$Hallo\.\$lesson\$,\s+null,/)
    expect(sql).toContain('$lesson$Code.$lesson$')
  })

  it('entfernt Lektionen eines Kurses, die es im Inhalt nicht mehr gibt', () => {
    expect(buildSeedSql(courses)).toMatch(/delete from public\.lessons\s+where course_id = \(select id from public\.courses where slug = 'todo-app'\)\s+and slug not in \('seite'\)/)
  })

  it('lehnt einen empfohlenen Kurs ab, den es nicht gibt', () => {
    const broken = [{ ...courses[1], recommended: 'gibt-es-nicht' }]
    expect(() => buildSeedSql(broken)).toThrow(/gibt-es-nicht/)
  })

  it('lehnt doppelte Positionen innerhalb eines Kurses ab', () => {
    const lesson = courses[0].lessons[0]
    const broken = [{ ...courses[0], lessons: [lesson, { ...lesson, slug: 'zwei' }] }]
    expect(() => buildSeedSql(broken)).toThrow(/Position 1/)
  })
})
```

- [ ] **Step 2: Tests laufen lassen und Fehlschlag prüfen**

Run: `yarn test tests/unit/courseContent.test.js`
Expected: FAIL, `scripts/course-content.mjs` wird nicht gefunden.

- [ ] **Step 3: `scripts/course-content.mjs` schreiben**

Reine Funktionen ohne Dateizugriff, die die Tests aus Step 1 erfüllen:

- `parseLesson(fileName, text)`: Zeilenenden auf `\n` vereinheitlichen; Dateiname gegen `/^(\d{2})-([a-z0-9-]+)\.md$/` prüfen; den Kopf zwischen den ersten beiden `---`-Zeilen als `schlüssel: wert` lesen; `section` gegen `start`, `html`, `css`, `js`, `abschluss` prüfen; den Rest an der ersten Zeile, die genau `<!-- loesung -->` ist, teilen; beide Teile mit `trim()` kürzen; leeren Inhalt ablehnen; eine leere Musterlösung zu `null` machen.
- Prüfung auf Renderer-Befehle: Zeile für Zeile über den ganzen Text nach dem Kopf (Inhalt und Musterlösung), mit der Zeilennummer der Datei (erste Zeile ist 1). Zeilen innerhalb eines Codeblocks (zwischen Zeilen, die mit ```` ``` ```` beginnen) überspringen. In den übrigen Zeilen zuerst alle Inline-Code-Abschnitte (`` `…` ``) entfernen, dann melden: `{{` irgendwo, oder ein `:` am Wortanfang, auf das ein Buchstabe folgt (regulärer Ausdruck `/(^|[\s(])[:@][A-Za-zÄÖÜäöü]/`; das erfasst auch `@click`). Fehlertext: `<dateiname>:<zeile>: …`.
- `$lesson$` irgendwo im Text nach dem Kopf ablehnen.
- `extractFiles(markdown)`: Codeblöcke mit Kopfzeile ```` ```sprache [pfad] ```` finden; `code` ist der Inhalt bis zur schließenden Zeile, mit abschließendem Zeilenumbruch; Pfade mit `..`, führendem `/` oder Laufwerksbuchstaben ablehnen.
- `buildSeedSql(courses)`: vor dem Erzeugen prüfen, dass Adressteile und Positionen der Kurse eindeutig sind, dass je Kurs Adressteile und Positionen der Lektionen eindeutig sind (Fehlertext nennt `Position <n>` bzw. den Adressteil) und dass jeder `recommended`-Wert ein Kurs der Liste ist. Ausgabe in dieser Reihenfolge:
  1. Kommentar: erzeugt von `yarn content:seed`, nicht von Hand ändern, nur einmal einspielen, überschreibt Änderungen aus dem Dashboard.
  2. `insert into public.courses (slug, title, summary, position, published) values (…), (…) on conflict (slug) do update set title = excluded.title, summary = excluded.summary, position = excluded.position, published = excluded.published;` mit `published` immer `true`.
  3. Je Kurs: `update public.courses set recommended_course_id = (select id from public.courses where slug = '<empfohlen>') where slug = '<kurs>';` bzw. `… = null …`, wenn nichts empfohlen wird.
  4. Je Kurs: `delete from public.lessons where course_id = (select id from public.courses where slug = '<kurs>') and slug not in ('<a>', '<b>', …);`
  5. Je Kurs ein `insert into public.lessons (course_id, slug, title, summary, position, section, content, solution, published) values …` mit `course_id` als `(select id from public.courses where slug = '<kurs>')`, Text in `$lesson$…$lesson$`, fehlender Musterlösung als `null`, `published` immer `true`, und `on conflict (course_id, slug) do update set title = excluded.title, summary = excluded.summary, position = excluded.position, section = excluded.section, content = excluded.content, solution = excluded.solution, published = excluded.published;`
  
  Weil `(course_id, position)` eindeutig ist, können Upserts an vertauschten Positionen scheitern. Deshalb vor Schritt 5 je Kurs: `update public.lessons set position = position + 1000 where course_id = (select id from public.courses where slug = '<kurs>');`
  
  Einfache Anführungszeichen in `title`, `summary` und Adressteilen werden verdoppelt.

- [ ] **Step 4: Tests laufen lassen**

Run: `yarn test`
Expected: PASS, 5 Dateien, 63 Tests.

- [ ] **Step 5: `scripts/build-seed.mjs` schreiben**

Liest alle Unterordner von `kursinhalt/` mit einer `kurs.json`, darin alle `*.md` außer `README.md`, ruft `parseLesson` und `buildSeedSql` auf und schreibt `supabase/seeds/courses.sql` (UTF-8, `\n`). Gibt je Kurs Adressteil und Anzahl der Lektionen aus. Bei einem Fehler: Meldung auf stderr, Exit-Code 1, keine Datei schreiben.

In `package.json` unter `scripts` ergänzen:

```json
"content:seed": "node scripts/build-seed.mjs",
"content:verify": "node scripts/verify-course.mjs"
```

- [ ] **Step 6: `scripts/verify-course.mjs` schreiben**

Aufruf: `yarn content:verify <kurs-slug> [--from <NN>] [--to <NN>]`.

1. Prüfprojekt anlegen, falls es noch nicht existiert: Ordner `<Temp-Verzeichnis des Systems>/kurs-check-<kurs-slug>` (über `os.tmpdir()`), darin ein frisches Nuxt-Projekt, erzeugt mit demselben Befehl, den die Lektion „Projekt anlegen“ den Lernenden gibt (`npm create nuxt@latest`), in der nicht-interaktiven Form; danach `npm install tailwindcss @tailwindcss/vite @lucide/vue`. Die genauen Schalter für den nicht-interaktiven Aufruf durch Ausprobieren ermitteln und im Skript festhalten.
2. Den Ausgangszustand der vom Kurs berührten Dateien merken (Kopie in `<Prüfprojekt>/.kurs-original/`), damit ein erneuter Lauf wieder bei Lektion 1 beginnen kann: Vor jedem Lauf werden die Dateien aus dieser Kopie zurückgespielt und Dateien, die der Kurs neu anlegt, gelöscht.
3. Lektionen in Reihenfolge lesen. Für jede Lektion mit Musterlösung: `extractFiles(solution)` in das Prüfprojekt schreiben (Ordner anlegen), dann im Prüfprojekt `npx nuxt build` ausführen. Schlägt der Build fehl: Lektion, Datei und die letzten 40 Zeilen der Ausgabe zeigen, Exit-Code 1.
4. Nach der letzten Lektion (oder `--to`): die gebaute App auf einem freien Port ungleich 3000 starten (`node .output/server/index.mjs` mit `PORT`), `/` abrufen, HTTP 200 prüfen, den Serverprozess beenden.
5. Am Ende je Lektion eine Zeile ausgeben: Position, Adressteil, geschriebene Dateien, `ok`.

Das Skript beendet jeden Prozess, den es startet, auch im Fehlerfall.

- [ ] **Step 7: Werkzeuge mit einer Probelektion prüfen**

Vorübergehend anlegen: `kursinhalt/probe/kurs.json` (`slug: "probe"`, `position: 99`) und `kursinhalt/probe/01-seite.md` mit einer Musterlösung, die `app/app.vue` durch ein Template mit einer Überschrift ersetzt.

Run: `yarn content:verify probe`
Expected: eine Zeile `01 seite app/app.vue ok`, Exit-Code 0, kein Prozess bleibt zurück.

Dann in der Probelektion im Template ein schließendes Tag entfernen und erneut ausführen.
Expected: Exit-Code 1, die Meldung nennt `01 seite`.

Run: `yarn content:seed`
Expected: `supabase/seeds/courses.sql` entsteht und enthält `'probe'`.

Danach `kursinhalt/probe/` und `supabase/seeds/courses.sql` wieder löschen.

- [ ] **Step 8: `kursinhalt/README.md` schreiben**

Kurz, auf Deutsch: Ordneraufbau, Format von `kurs.json` und Lektionsdateien, der Marker für die Musterlösung, die Regel zu `{{ }}`, `:` und `@`, die beiden Befehle, und der Hinweis, dass `courses.sql` nur einmal eingespielt wird und danach die Datenbank maßgeblich ist.

- [ ] **Step 9: Commit**

```powershell
git add scripts kursinhalt/README.md tests/unit/courseContent.test.js package.json
git commit -m "Add course content tooling: parser, seed generator and build check"
```

---

### Task 2: Kurs „Erste Schritte“

**Files:**
- Create: `kursinhalt/erste-schritte/kurs.json`, `01-willkommen.md`, `02-werkzeuge-einrichten.md`, `03-das-terminal-kennenlernen.md`

**Interfaces:**
- Consumes: Format und `yarn content:seed` aus Task 1
- Produces: Kurs `erste-schritte` mit drei Lektionen im Block `start`, ohne Musterlösungen

`kurs.json`: `slug` `erste-schritte`, `title` „Erste Schritte“, `position` 1, kein `recommended`, `summary` ein Satz dazu, dass man hier den Rechner einrichtet und lernt, wie die Kurse funktionieren.

| Datei | Titel | Inhalt |
|---|---|---|
| `01-willkommen.md` | Willkommen | Für wen die Kurse sind; dass man auf dem eigenen Rechner arbeitet und nichts kaputt machen kann; wie eine Lektion aufgebaut ist (Erklärung, eigene Aufgabe, Musterlösung); wie man eine Lektion abschließt und dass ein Konto den Fortschritt speichert; was man braucht (Rechner mit Windows oder macOS, Internet, etwa eine Stunde für diesen Kurs). |
| `02-werkzeuge-einrichten.md` | Werkzeuge einrichten | Was Node.js ist und wofür man es braucht (ein Satz); Installation der LTS-Version von nodejs.org; was ein Code-Editor ist; Installation von VS Code von code.visualstudio.com; die Erweiterung „Vue (Official)“ installieren. Am Ende: woran man erkennt, dass beides installiert ist (Verweis auf die nächste Lektion für die Prüfung im Terminal). |
| `03-das-terminal-kennenlernen.md` | Das Terminal kennenlernen | Was ein Terminal ist; wie man es öffnet (Windows: PowerShell bzw. das Terminal in VS Code; macOS: Terminal); `node --version` und `npm --version` als erste Befehle mit der erwarteten Art von Ausgabe; `cd`, `cd ..`, `ls`, `mkdir`; einen Ordner `projekte` anlegen und hineinwechseln; wie man einen laufenden Befehl mit Strg+C beendet. Am Ende der Verweis auf den Kurs „Todo-App“. |

- [ ] **Step 1: Die drei Befehle der dritten Lektion ausführen**

`node --version`, `npm --version`, `mkdir`, `cd`, `ls` in PowerShell ausführen und die Form der Ausgabe notieren. Die Lektion nennt keine feste Versionsnummer, sondern die Form („eine Zeile wie `v24.x.x`“).

- [ ] **Step 2: `kurs.json` und die drei Lektionen schreiben**

Nach dem Format, der Tabelle und den Schreibregeln oben. Diese Lektionen haben keinen Abschnitt „Deine Aufgabe“ und keine Musterlösung; Lektion 2 und 3 enden mit einer kurzen Liste „Das solltest du jetzt haben“.

- [ ] **Step 3: Format prüfen**

Run: `yarn content:seed`
Expected: Ausgabe `erste-schritte: 3 Lektionen`, Exit-Code 0. Die erzeugte `supabase/seeds/courses.sql` wird in dieser Task nicht committet (wieder löschen).

- [ ] **Step 4: Commit**

```powershell
git add kursinhalt/erste-schritte
git commit -m "Add course content: Erste Schritte"
```

---

### Task 3: Kurs „Todo-App“, Lektionen 1 bis 8 (Start, HTML, CSS)

**Files:**
- Create: `kursinhalt/todo-app/kurs.json` und die Lektionsdateien `01` bis `08`

**Interfaces:**
- Consumes: Format, `yarn content:verify` und `yarn content:seed` aus Task 1; die fertige App aus diesem Plan
- Produces: Stand nach Lektion 8: `nuxt.config.ts` und `app/assets/css/main.css` wie in der fertigen App; `app/app.vue` ohne `<script setup>`-Logik außer dem Icon-Import, mit dem vollständigen, gestylten Template der fertigen App, aber festen Beispielaufgaben: drei `<li>` direkt im Template (eine davon im erledigten Aussehen), eine feste Zeile „2 offen“ und dem sichtbaren Button „Alle löschen“; alle Buttons ohne Funktion

`kurs.json` wie im Abschnitt „Format der Lektionsdateien“.

| Datei | Block | Titel | Neu in dieser Lektion | Deine Aufgabe | Stand danach |
|---|---|---|---|---|---|
| `01-was-wir-bauen.md` | start | Was wir bauen | Beschreibung der fertigen App und ihrer Funktionen; die drei Durchgänge HTML, CSS, JavaScript; Hinweis auf „Erste Schritte“ | keine | unverändert |
| `02-projekt-anlegen.md` | start | Projekt anlegen | `npm create nuxt@latest todo-app` mit den Abfragen, wie sie wirklich erscheinen; `cd todo-app`; `npm run dev`; `http://localhost:3000`; Ordner in VS Code öffnen; kurzer Blick auf `app/app.vue`, `nuxt.config.ts`, `package.json`, `node_modules` | keine | frisches Projekt |
| `03-die-erste-seite.md` | html | Die erste Seite | Was ein Template ist; Tags, öffnend und schließend; `<h1>` und `<p>` am Beispiel einer Überschrift | Unter der Überschrift einen Absatz mit einem eigenen Satz ergänzen | `app/app.vue` nur mit `<template>`: `<h1>Meine Aufgaben</h1>` und ein `<p>` |
| `04-das-geruest-der-todo-app.md` | html | Das Gerüst der Todo-App | `<main>`, `<form>`, `<input>`, `<button>`, `<ul>` und `<li>`; Attribute (`type`, `placeholder`); gezeigt wird das Formular | Die Liste mit drei Beispielaufgaben bauen, jede mit zwei Buttons „Erledigt“ und „Löschen“, darunter ein Button „Alle löschen“ | vollständiges Gerüst ohne Klassen |
| `05-tailwind-einrichten.md` | css | Tailwind einrichten | Was CSS ist und was Tailwind anders macht; `npm install tailwindcss @tailwindcss/vite`; `nuxt.config.ts` und `app/assets/css/main.css` anpassen (beides wird im Text gezeigt, weil es Einrichtung ist); Klassen an der Überschrift | Dem Absatz „2 offen“ unter der Überschrift eine kleinere, graue Schrift geben | Konfiguration wie fertige App; Überschrift und Zähler gestylt |
| `06-die-app-stylen.md` | css | Die App stylen | Abstände (`p-`, `m-`, `gap-`), Farben, Ecken, `flex`; gezeigt werden Seitenhintergrund und Karte | Formular und Listeneinträge stylen, sodass Eingabefeld und Button nebeneinander stehen und jeder Eintrag einen Rahmen hat | Layout wie fertige App, Buttons noch mit Text |
| `07-icons-mit-lucide.md` | css | Icons mit Lucide | `npm install @lucide/vue`; erstes `<script setup>` nur für den Import; ein Icon als Tag verwenden; `aria-label` für Buttons ohne Text; gezeigt wird das Icon neben der Überschrift | Die Buttons zum Hinzufügen, Abhaken und Löschen auf Icons umstellen | Icons wie fertige App |
| `08-feinschliff.md` | css | Feinschliff | `hover:`, `focus-visible:`, `transition-colors`; wie man die Ansicht am Handy im Browser prüft; gezeigt wird der Hover am Hinzufügen-Button | Den Löschen-Buttons und „Alle löschen“ einen Hover geben und einen Eintrag im erledigten Aussehen (durchgestrichen, grau, gefüllter Kreis) gestalten | Template wie fertige App mit festen Beispielaufgaben |

- [ ] **Step 1: `npm create nuxt@latest` wirklich ausführen**

In einem Ordner außerhalb des Repos (`os.tmpdir()`), interaktiv nicht möglich: die Abfragen über `npm create nuxt@latest -- --help` und einen nicht-interaktiven Lauf ermitteln; zusätzlich den Inhalt der erzeugten `app/app.vue`, `nuxt.config.ts` und `package.json` lesen. Lektion 2 beschreibt genau diese Abfragen und Dateien. Den Ordner danach löschen.

- [ ] **Step 2: Icon-Namen prüfen**

Im Prüfprojekt aus Task 1 (oder nach `npm install @lucide/vue` in einem Temp-Ordner) prüfen, dass `ListTodo`, `Plus`, `Check` und `Trash2` aus `@lucide/vue` exportiert werden. Fehlt einer, den nächstliegenden vorhandenen Namen wählen, im Bericht nennen und überall einheitlich verwenden (auch in der Vorgabe für Task 4).

- [ ] **Step 3: `kurs.json` und die Lektionen 1 bis 8 schreiben**

Nach Format, Tabelle und Schreibregeln. Die Musterlösung jeder Lektion zeigt alle in der Lektion geänderten Dateien vollständig. Für Lektion 5 sind das `nuxt.config.ts`, `app/assets/css/main.css` und `app/app.vue`.

- [ ] **Step 4: Jeden Zwischenstand bauen**

Run: `yarn content:verify todo-app --to 08`
Expected: je Lektion mit Musterlösung (3 bis 8) eine Zeile mit `ok`, HTTP 200 für die Startseite, Exit-Code 0.

Schlägt ein Stand fehl: die Lektion korrigieren und erneut ausführen, bis alle Stände bauen.

- [ ] **Step 5: Stand nach Lektion 8 mit der fertigen App vergleichen**

Die Musterlösung von Lektion 8 neben `app/app.vue` und `app/components/TaskItem.vue` der fertigen App legen: Jede Klasse der fertigen App an `<main>`, Karte, Kopf, Formular, Eingabefeld, Buttons, Liste und Listeneintrag muss in Lektion 8 vorkommen (der Listeneintrag steht hier noch direkt in `app/app.vue`). Abweichungen beheben oder im Bericht begründen.

- [ ] **Step 6: Format prüfen und committen**

Run: `yarn content:seed`
Expected: `todo-app: 8 Lektionen`, Exit-Code 0. Die erzeugte `supabase/seeds/courses.sql` wieder löschen.

```powershell
git add kursinhalt/todo-app
git commit -m "Add course content: Todo-App lessons 1-8"
```

---

### Task 4: Kurs „Todo-App“, Lektionen 9 bis 16 (JavaScript, Abschluss)

**Files:**
- Create: die Lektionsdateien `09` bis `16` in `kursinhalt/todo-app/`

**Interfaces:**
- Consumes: Stand nach Lektion 8 aus Task 3 (die Musterlösung von `08-feinschliff.md` lesen); die fertige App aus diesem Plan
- Produces: Stand nach Lektion 15 gleich der fertigen App; Lektion 16 mit dem vollständigen Code

| Datei | Block | Titel | Neu in dieser Lektion | Deine Aufgabe | Stand danach |
|---|---|---|---|---|---|
| `09-daten-anzeigen.md` | js | Daten anzeigen | Was JavaScript in der App tut; Variablen; `ref` und warum; ein Objekt mit `id`, `title`, `done`; Ausgabe mit `{{ }}` am Beispiel eines einzelnen Werts | Die drei festen Einträge durch eine Liste `tasks` mit drei Objekten und ein `<li>` mit `v-for` und `:key` ersetzen | `tasks` als `ref` mit drei Beispielobjekten, ein `<li v-for>`; Aussehen „erledigt“ noch nicht an Daten gebunden |
| `10-aufgaben-hinzufuegen.md` | js | Aufgaben hinzufügen | Funktionen; `v-model`; `@submit.prevent`; `push`; gezeigt wird `newTask` mit `v-model` und eine Ausgabe des getippten Texts | `addTask` schreiben: neue Aufgabe mit `id`, `title`, `done: false` anhängen, Feld leeren, leere Eingaben ignorieren | `newTask`, `addTask` wie fertige App |
| `11-aufgaben-abhaken.md` | js | Aufgaben abhaken | `@click` mit Argument; `find`; Wahrheitswerte umdrehen mit `!`; `:class` mit Bedingung, gezeigt am durchgestrichenen Text | `checkTask` schreiben und den Kreis-Button je nach `done` gefüllt oder leer darstellen, mit passendem `aria-label` | `checkTask` und beide `:class` wie fertige App (noch in `app/app.vue`) |
| `12-aufgaben-loeschen.md` | js | Aufgaben löschen | `filter` am Beispiel eines Zahlen-Arrays; warum man der Liste das Ergebnis neu zuweist | `deleteTask` schreiben und mit dem Papierkorb-Button verbinden | `deleteTask` wie fertige App |
| `13-zaehler-und-leere-liste.md` | js | Zähler und leere Liste | `computed` und der Unterschied zu einer Funktion; `v-if` und `v-else`, gezeigt am Hinweistext für die leere Liste | `openCount` als `computed` schreiben und statt der festen „2 offen“ anzeigen | `openCount`, `v-if`/`v-else` wie fertige App; die drei Beispielaufgaben bleiben als Startwert |
| `14-in-komponenten-aufteilen.md` | js | In Komponenten aufteilen | Warum Komponenten; Datei in `app/components/`; `defineProps`; gezeigt wird eine Komponente, die nur den Titel anzeigt | `TaskItem` fertigstellen: den ganzen Listeneintrag verschieben, die Klicks mit `defineEmits` und `$emit` nach oben melden und in `app/app.vue` mit `@check` und `@delete` verbinden | `app/components/TaskItem.vue` und `<TaskItem>` wie fertige App |
| `15-speichern-im-browser.md` | js | Speichern im Browser | `localStorage`, `JSON.stringify` und `JSON.parse`; `watch` mit `deep`; warum das Laden in `onMounted` steht (der Server kennt den Speicher des Browsers nicht); gezeigt wird das Speichern | Das Laden in `onMounted` ergänzen, die Beispielaufgaben durch eine leere Liste ersetzen und `clearTasks` für „Alle löschen“ schreiben; der Button erscheint nur, wenn es Aufgaben gibt | genau die fertige App |
| `16-geschafft.md` | abschluss | Geschafft | Rückblick in drei Absätzen (HTML, CSS, JavaScript); fünf Ideen zum Weitermachen (zum Beispiel Aufgaben bearbeiten, Filter „offen/erledigt“, Fälligkeitsdatum, eigenes Farbschema, die App veröffentlichen); danach der vollständige Code aller vier Dateien der fertigen App | keine | unverändert |

Lektion 16 hat keine Musterlösung; der vollständige Code steht im Lektionstext unter `## Der vollständige Code`, je Datei ein Codeblock mit Pfad.

- [ ] **Step 1: Lektionen 9 bis 16 schreiben**

Nach Format, Tabelle und Schreibregeln. Ausgangspunkt ist die Musterlösung von Lektion 8.

- [ ] **Step 2: Jeden Zwischenstand bauen**

Run: `yarn content:verify todo-app`
Expected: je Lektion mit Musterlösung (3 bis 15) eine Zeile mit `ok`, HTTP 200 für die Startseite, Exit-Code 0.

- [ ] **Step 3: Stand nach Lektion 15 mit der fertigen App vergleichen**

Im Prüfprojekt liegen nach dem Lauf die vier Dateien im Stand nach Lektion 15. Sie müssen mit den vier Dateien im Abschnitt „Die fertige Todo-App“ übereinstimmen (Leerraum am Zeilenende ausgenommen; begründete Abweichungen aus Task 3 ausgenommen). Dasselbe gilt für die vier Codeblöcke in Lektion 16: Sie müssen zeichengleich mit dem Stand nach Lektion 15 sein.

- [ ] **Step 4: Verhalten der fertigen App prüfen**

Im Prüfprojekt einen Vitest-freien Schnelltest als Node-Skript außerhalb des Repos ausführen, der die Logik aus `app/app.vue` nachstellt: `addTask` mit „  Milch  “ ergibt eine Aufgabe mit `title` „Milch“ und leert das Feld; `addTask` mit „   “ ändert nichts; `checkTask` dreht `done` um und beim zweiten Aufruf zurück; `deleteTask` entfernt genau die Aufgabe mit der `id`; `clearTasks` leert die Liste; `openCount` zählt nur offene Aufgaben. Dazu die Funktionen aus dem `<script setup>`-Block der Musterlösung von Lektion 15 in eine `.mjs`-Datei mit `import { ref, computed } from 'vue'` kopieren. Ergebnis im Bericht festhalten.

- [ ] **Step 5: Format prüfen und committen**

Run: `yarn content:seed`
Expected: `erste-schritte: 3 Lektionen`, `todo-app: 16 Lektionen`, Exit-Code 0. Die erzeugte `supabase/seeds/courses.sql` wieder löschen.

```powershell
git add kursinhalt/todo-app
git commit -m "Add course content: Todo-App lessons 9-16"
```

---

### Task 5: Einspielen und Abnahme

**Files:**
- Create: `supabase/seeds/courses.sql` (erzeugt)
- Delete: `supabase/seeds/sample_courses.sql`

**Interfaces:**
- Consumes: alles aus Task 1 bis 4
- Produces: In der Datenbank genau zwei veröffentlichte Kurse mit 3 und 16 veröffentlichten Lektionen; keine Beispielkurse mehr

- [ ] **Step 1: Seed erzeugen**

Run: `yarn content:seed`
Expected: `erste-schritte: 3 Lektionen`, `todo-app: 16 Lektionen`.

- [ ] **Step 2: Beispielkurse entfernen**

Die Beispielkurse `leerer-kurs` und `entwurfskurs` gibt es im echten Inhalt nicht. Löschen (Lektionen und Kursstände hängen per Fremdschlüssel daran):

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db query --linked "delete from public.courses where slug in ('leerer-kurs', 'entwurfskurs') returning slug"
```

Expected: zwei Zeilen. Danach `supabase/seeds/sample_courses.sql` löschen.

- [ ] **Step 3: Kursinhalt einspielen**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db query --linked -f supabase/seeds/courses.sql; yarn -s supabase db query --linked "select c.slug, c.position, c.published, (select slug from public.courses r where r.id = c.recommended_course_id) as recommended, count(l.id) as lessons, count(l.id) filter (where l.published) as published_lessons, count(l.id) filter (where l.solution is not null) as with_solution from public.courses c left join public.lessons l on l.course_id = c.id group by c.id order by c.position"
```

Expected: genau zwei Zeilen: `erste-schritte` (Position 1, veröffentlicht, keine Empfehlung, 3 / 3 / 0) und `todo-app` (Position 2, veröffentlicht, empfiehlt `erste-schritte`, 16 / 16 / 13).

Zusätzlich prüfen, dass keine Beispiel-Lektion übrig ist und die Positionen lückenlos sind:

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db query --linked "select c.slug as course, l.position, l.slug, l.section from public.lessons l join public.courses c on c.id = l.course_id order by c.position, l.position"
```

Expected: 19 Zeilen, Positionen 1 bis 3 und 1 bis 16, Adressteile wie die Dateinamen in `kursinhalt/`.

- [ ] **Step 4: Zugriffsregeln prüfen**

```powershell
Get-Content .env | ForEach-Object { $p = $_ -split '=',2; if ($p[0].Trim()) { Set-Item "env:$($p[0].Trim())" $p[1].Trim() } }; yarn -s supabase db query --linked -f supabase/tests/rls.sql
```

Expected: `rls ok`.

- [ ] **Step 5: Jede Lektion auf der Seite abrufen**

Antwortet `http://localhost:3000`, diesen Server benutzen und nicht beenden; sonst `yarn dev` selbst starten und danach beenden.

Für jede der 19 Lektionen `/kurse/<kurs>/<lektion>` abrufen und prüfen:

1. HTTP 200.
2. Das HTML enthält den Titel der Lektion.
3. Das HTML enthält außerhalb von `<pre>` und `<code>` weder `{{` noch `}}` und keinen unaufgelösten Baustein (kein `<undefined`, kein sichtbares `:class` als eigenes Element).
4. Lektionen mit Musterlösung enthalten `Musterl` und mindestens ein Element mit der Klasse `code-block`; Lektionen ohne Musterlösung enthalten kein `Musterl`.
5. Jeder Codeblock mit Dateipfad zeigt den Pfad in seiner Leiste.

Außerdem: `/kurse` enthält genau die zwei Kurse; `/kurse/todo-app` zeigt den Hinweis auf „Erste Schritte“ und 16 Lektionen in fünf Blöcken; `/kurse/leerer-kurs` antwortet 404.

Jede Abweichung in der betroffenen Lektionsdatei beheben, `yarn content:seed` erneut ausführen, die SQL-Datei erneut einspielen und die Prüfung wiederholen.

- [ ] **Step 6: Tests und Commit**

Run: `yarn test`
Expected: PASS, 63 Tests.

```powershell
git add -A supabase/seeds kursinhalt
git commit -m "Seed real courses and remove sample data"
```
