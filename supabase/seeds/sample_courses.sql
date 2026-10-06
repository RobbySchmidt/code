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
