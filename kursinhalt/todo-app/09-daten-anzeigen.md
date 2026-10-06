---
title: Daten anzeigen
summary: Du lernst Variablen, Listen und Objekte kennen und lässt die App ihre Aufgaben aus Daten erzeugen.
section: js
---

Der dritte Durchgang beginnt: JavaScript. Bisher steht jede Aufgabe als fester Text im Template. Eine App, in der Aufgaben dazukommen und verschwinden, braucht sie aber als Daten, die sich ändern können. JavaScript verwaltet diese Daten, und das Template zeigt sie an.

## Eine Variable

JavaScript steht in `<script setup>`, wo schon der Import der Icons steht. Eine **Variable** ist ein Name, unter dem sich das Programm einen Wert merkt. Schreib zur Probe unter den Import, mit einer Leerzeile Abstand:

```js
const greeting = ref('Hallo aus JavaScript')
```

`const` kündigt eine neue Variable an. Dahinter steht ihr Name, und nach dem Gleichheitszeichen folgt ihr Wert. Text steht in JavaScript in einfachen Anführungszeichen.

Setze nun im Template direkt unter den Absatz „2 offen“ diese Zeile:

```vue
<p>{{ greeting }}</p>
```

Speichere. Unter „2 offen“ steht „Hallo aus JavaScript“. Doppelte geschweifte Klammern im Template heißen: Zeig an dieser Stelle den Wert der Variable.

## Wozu `ref`?

Um die Anzeige kümmert sich **Vue**, ein Baustein, der in Nuxt steckt. Ein **Ref** ist eine Hülle um einen Wert, die Vue beobachtet: Ändert sich der Wert, zeichnet Vue die betroffenen Stellen der Seite neu. Du erzeugst die Hülle mit `ref` und schreibst den Startwert in die runden Klammern.

Einen Import wie bei den Icons braucht `ref` nicht. Nuxt stellt es in jeder Vue-Datei von selbst bereit.

Lösche die beiden Probezeilen wieder.

## Listen und Objekte

Ein **Array** ist eine Liste von Werten. Sie stehen in eckigen Klammern, getrennt durch Kommas.

Ein **Objekt** bündelt mehrere Werte, die zusammengehören, und gibt jedem einen Namen. Es steht in geschweiften Klammern:

```js
const book = { title: 'Momo', pages: 304, read: true }
```

Dieses Buch hat einen Text, eine Zahl und einen Wahrheitswert. Ein **Wahrheitswert** kennt nur zwei Möglichkeiten: `true` für wahr und `false` für falsch. An einen einzelnen Wert kommst du mit einem Punkt: `book.title` ist der Text „Momo“.

## Ein Tag für jeden Eintrag

Das Attribut `v-for` wiederholt ein Tag für jeden Eintrag eines Arrays. Ein Beispiel, das nicht in die App gehört:

```vue
<script setup>
const names = ref(['Anna', 'Ben', 'Cem'])
</script>

<template>
  <ul>
    <li v-for="name in names" :key="name">{{ name }}</li>
  </ul>
</template>
```

Daraus entstehen drei `<li>`. `name in names` heißt: Geh die Liste `names` durch und nenne den jeweiligen Eintrag `name`. Diesen Namen darfst du innerhalb des Tags benutzen.

Ein Doppelpunkt vor einem Attribut bedeutet: Der Wert ist kein fester Text, sondern JavaScript. `:key` gibt jedem Eintrag ein eindeutiges Kennzeichen, damit Vue die Einträge auseinanderhalten kann.

## Deine Aufgabe

Lege im Script-Teil die Variable `tasks` an: ein Ref mit einem Array aus drei Objekten. Jedes Objekt hat eine `id` (die Zahlen 1, 2 und 3), einen `title` mit dem Text der Aufgabe und ein `done`, das bei der ersten Aufgabe `true` ist und bei den anderen `false`.

Im Template bleibt ein einziges `<li>` übrig. Es wird für jede Aufgabe wiederholt, bekommt die `id` als Kennzeichen und zeigt statt des festen Textes den `title`.

Tipp: Behalte eines der beiden offenen `<li>` und lösche die anderen zwei. Ein Array darf über mehrere Zeilen gehen, am übersichtlichsten ist ein Objekt je Zeile.

Wenn es geklappt hat, zeigt der Browser dieselben drei Aufgaben wie vorher, jetzt alle mit leerem Kreis. Dass die erste nicht mehr erledigt aussieht, ist richtig: Mit `done` verbindest du das Aussehen in der übernächsten Lektion. Änderst du im Script-Teil einen `title`, ändert sich der Eintrag in der Liste.

### Wenn es nicht klappt

- **Die Liste ist leer, oder eine Meldung sagt, `tasks` oder `task` sei nicht definiert:** Ein Name ist an einer Stelle anders geschrieben als an der anderen. `tasks` ist die ganze Liste, `task` der einzelne Eintrag.
- **Alle drei Einträge zeigen denselben Text:** Im `<span>` steht noch der feste Text statt `{{ task.title }}`.
- **Das Terminal oder der Browser meldet einen Fehler im Script-Teil:** Meist fehlt ein Komma zwischen zwei Objekten, eine schließende Klammer oder ein Anführungszeichen.

<!-- loesung -->

```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">2 offen</p>

      <form class="mt-6 flex gap-2">
        <input
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

      <ul class="mt-6 space-y-2">
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2"
        >
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 border-slate-300 text-transparent hover:border-indigo-600"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words text-slate-900">{{ task.title }}</span>
          <button
            type="button"
            aria-label="Aufgabe löschen"
            class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            <Trash2 class="size-4" />
          </button>
        </li>
      </ul>

      <button
        type="button"
        class="mt-6 flex items-center gap-2 text-sm text-slate-500 transition-colors hover:text-red-600"
      >
        <Trash2 class="size-4" />
        Alle löschen
      </button>
    </div>
  </main>
</template>
```
