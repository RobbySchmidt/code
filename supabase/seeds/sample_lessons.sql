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
