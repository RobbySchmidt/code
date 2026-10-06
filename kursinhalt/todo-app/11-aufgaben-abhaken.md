---
title: Aufgaben abhaken
summary: Ein Klick auf den Kreis hakt eine Aufgabe ab, und ihr Aussehen richtet sich nach den Daten.
section: js
---

Jede Aufgabe trägt den Wert `done` in sich, aber man sieht ihn nicht. In dieser Lektion richtet sich das Aussehen nach `done`, und ein Klick auf den Kreis ändert es.

## Klassen mit Bedingung

Den Doppelpunkt vor einem Attribut kennst du von `:key`: Der Wert ist JavaScript. Vor `class` erlaubt er, Klassen von einer Bedingung abhängig zu machen. Dafür gibt es eine kurze Schreibweise mit Fragezeichen und Doppelpunkt:

```js
task.done ? 'text-slate-400 line-through' : 'text-slate-900'
```

Vorn steht die Bedingung. Ist sie wahr, gilt der Wert hinter dem Fragezeichen, sonst der hinter dem Doppelpunkt.

Ändere das `<span>` mit dem Aufgabentext so:

```vue
<span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
  {{ task.title }}
</span>
```

Die Klassen, die immer gelten, bleiben in `class`. Die Farbe ist nach `:class` gewandert. Ein Tag darf beide Attribute haben, Vue fügt die Klassen zusammen. Achte auf die Anführungszeichen: außen doppelte um das ganze Attribut, innen einfache um die beiden Texte.

Speichere. Die erste Aufgabe ist wieder grau und durchgestrichen, denn ihr `done` ist `true`.

## Auf einen Klick reagieren

`@click` ruft eine Funktion auf, wenn jemand auf das Tag klickt. Dabei kannst du der Funktion etwas mitgeben. Ein **Argument** ist ein Wert, den eine Funktion beim Aufruf bekommt. Sie nimmt ihn unter dem Namen entgegen, der in ihren runden Klammern steht. Ein Beispiel, das nicht in die App gehört:

```vue
<script setup>
const message = ref('')

function greet(name) {
  message.value = 'Hallo ' + name
}
</script>

<template>
  <button type="button" @click="greet('Anna')">Anna grüßen</button>
  <p>{{ message }}</p>
</template>
```

Ein Klick auf den Button ruft `greet` auf, und in der Funktion hat `name` den Wert „Anna“. Statt eines festen Textes kannst du auch eine Variable mitgeben, innerhalb eines `v-for` zum Beispiel einen Wert des aktuellen Eintrags.

## Einen Eintrag finden und einen Wert umdrehen

`find` geht ein Array durch und liefert den ersten Eintrag, für den eine Bedingung wahr ist:

```js
const books = ref([
  { id: 1, title: 'Momo' },
  { id: 2, title: 'Krabat' }
])

const book = books.value.find(book => book.title === 'Krabat')
book.title = 'Krabat, neue Ausgabe'
```

In den Klammern von `find` steht eine Funktion in Kurzform. Vor dem Pfeil `=>` steht der Name für den Eintrag, der gerade geprüft wird, dahinter die Bedingung. `book` ist danach das zweite Objekt, und die letzte Zeile gibt ihm einen neuen Titel. `book` ist ein gewöhnliches Objekt und kein Ref, darum steht dort kein `.value`. Es ist auch keine Kopie: Die Änderung gilt in der Liste. Das `book` vor dem Pfeil und das `book` links vom Gleichheitszeichen sind zwei verschiedene Variablen mit zufällig gleichem Namen. In der Musterlösung gilt das auch für `task`.

Ein Ausrufezeichen vor einem Wahrheitswert dreht ihn um. Aus `true` wird `false` und umgekehrt:

```js
const lightOn = ref(true)
lightOn.value = !lightOn.value
```

Nach dieser Zeile ist `lightOn` aus. Führst du sie noch einmal aus, ist es wieder an.

## Deine Aufgabe

1. Schreib die Funktion `checkTask`. Sie bekommt eine `id`, sucht die Aufgabe mit dieser `id` und dreht deren `done` um. Ein Klick auf den Kreis ruft sie mit der `id` der Aufgabe auf.
2. Der Kreis einer erledigten Aufgabe ist gefüllt: `border-indigo-600 bg-indigo-600 text-white`. Der einer offenen ist leer: `border-slate-300 text-transparent hover:border-indigo-600`.
3. Der Name des Kreises für Vorleseprogramme lautet bei einer erledigten Aufgabe „Als offen markieren“, sonst „Als erledigt markieren“.

Tipp: Teile die Klassen des Kreises auf wie beim Text. Was immer gilt, bleibt in `class`, die beiden Zustände kommen nach `:class`. Auch `aria-label` darf einen Doppelpunkt davor und eine Bedingung als Wert bekommen.

Wenn es geklappt hat, füllt ein Klick auf einen leeren Kreis ihn mit einem Häkchen, und der Text wird durchgestrichen. Ein zweiter Klick macht beides rückgängig.

### Wenn es nicht klappt

- **Der Browser zeigt nach der Änderung an `:class` einen Fehler:** Die Anführungszeichen stimmen nicht. Steht innen ein doppeltes, endet das Attribut dort zu früh.
- **Der Klick bewirkt nichts:** `@click` steht nicht am Button mit dem Kreis, oder im Aufruf fehlt `task.id` in den Klammern.
- **Der Text wird durchgestrichen, aber der Kreis bleibt leer:** In `class` stehen noch Klassen für einen Zustand, zum Beispiel `text-transparent`. Sie gehören nur nach `:class`.
- **Der Klick bewirkt nichts, obwohl `@click` stimmt:** In der Funktion steht `task.value.done`. `.value` gehört nur hinter `tasks`. Die gefundene Aufgabe ist ein gewöhnliches Objekt.

<!-- loesung -->

```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
const newTask = ref('')

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
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">2 offen</p>

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

      <ul class="mt-6 space-y-2">
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2"
        >
          <button
            type="button"
            :aria-label="task.done ? 'Als offen markieren' : 'Als erledigt markieren'"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            :class="task.done ? 'border-indigo-600 bg-indigo-600 text-white' : 'border-slate-300 text-transparent hover:border-indigo-600'"
            @click="checkTask(task.id)"
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
