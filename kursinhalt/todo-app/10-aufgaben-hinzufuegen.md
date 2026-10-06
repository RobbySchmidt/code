---
title: Aufgaben hinzufügen
summary: Du verbindest das Eingabefeld mit einer Variable und schreibst deine erste Funktion.
section: js
---

Die Liste entsteht jetzt aus Daten. Es reicht also, den Daten eine Aufgabe hinzuzufügen, und sie erscheint auf der Seite.

## Das Eingabefeld verbinden

Zuerst muss JavaScript erfahren, was im Eingabefeld steht. Lege unter `tasks` eine zweite Variable an. Zwei Anführungszeichen ohne Inhalt sind ein leerer Text:

```js
const newTask = ref('')
```

Ergänze am `<input>` als erstes Attribut `v-model="newTask"` und setze zur Probe direkt unter `</form>` einen Absatz:

```vue
<p>{{ newTask }}</p>
```

Speichere und tippe etwas in das Feld. Dein Text erscheint Buchstabe für Buchstabe unter dem Formular. `v-model` verbindet ein Eingabefeld in beide Richtungen mit einer Variable: Tippst du, ändert sich die Variable. Ändert sich die Variable, ändert sich der Inhalt des Feldes.

Lösche den Probe-Absatz wieder. `newTask` und `v-model` bleiben.

## Funktionen

Eine **Funktion** ist ein Stück Programm mit einem Namen. Es läuft nicht sofort, sondern erst, wenn die Funktion aufgerufen wird. Ein Beispiel, das nicht in die App gehört:

```js
const numbers = ref([1, 2])

function addThree() {
  numbers.value.push(3)
}
```

Nach dem Wort `function` steht der Name, dann ein Paar runde Klammern, und in den geschweiften Klammern steht, was die Funktion tut.

- Im Script-Teil erreichst du den Inhalt eines Refs über `.value`. Nur im Template lässt du das weg, dort ergänzt Vue es für dich.
- `push` hängt einen Wert ans Ende eines Arrays an.

Ein zweites Beispiel zeigt drei weitere Werkzeuge:

```js
const userName = ref('  Anna ')
const greeting = ref('')

function greet() {
  const name = userName.value.trim()
  if (name === '') return
  greeting.value = 'Hallo ' + name
}
```

- `trim()` liefert einen Text ohne die Leerzeichen an Anfang und Ende. Aus „  Anna “ wird „Anna“.
- `if` prüft eine Bedingung, die in runden Klammern steht. `===` vergleicht zwei Werte und ist wahr, wenn sie gleich sind. `return` beendet die Funktion sofort. Die Zeile heißt also: Ist der Name leer, hör hier auf.
- Mit einem einfachen Gleichheitszeichen gibst du einem Ref einen neuen Wert.

Für die Aufgabe brauchst du außerdem `Date.now()`. Es liefert die aktuelle Uhrzeit als sehr große Zahl, gezählt in Tausendstelsekunden. Weil die Zahl jedes Mal eine andere ist, eignet sie sich als `id`.

## Auf das Abschicken reagieren

Ein `@` vor einem Attribut heißt: Wenn das hier passiert, ruf diese Funktion auf. So sähe das für die Funktion `greet` aus:

```vue
<form @submit.prevent="greet">
```

`@submit` reagiert auf das Abschicken des Formulars, also auf den Klick auf den Button und auf die Eingabetaste im Feld. Der Zusatz `.prevent` verhindert, dass der Browser dabei die Seite neu lädt, wie du es beim Bau des Gerüsts gesehen hast.

## Deine Aufgabe

Schreib die Funktion `addTask` und lass sie beim Abschicken des Formulars laufen.

Sie hängt an `tasks` ein neues Objekt an. Seine `id` ist eine Zahl, die es noch nicht gibt, sein `title` der getippte Text ohne Leerzeichen am Rand, und `done` ist `false`. Danach leert sie das Eingabefeld. Ist das Feld leer oder enthält es nur Leerzeichen, tut die Funktion nichts.

Tipp: Das Feld leerst du, indem du `newTask` einen leeren Text gibst. Den Rest erledigt `v-model`.

Wenn es geklappt hat, tippst du „Blumen gießen“, drückst die Eingabetaste, und die Aufgabe steht am Ende der Liste. Das Feld ist wieder leer. Ein Klick auf das Plus bei leerem Feld bewirkt nichts.

Nach dem Neuladen der Seite sind deine neuen Aufgaben weg. Das Speichern kommt am Ende des Kurses.

### Wenn es nicht klappt

- **Die Seite lädt beim Abschicken neu:** `.prevent` fehlt, oder das Attribut steht nicht am `<form>`.
- **Beim Abschicken passiert nichts:** Im Script-Teil fehlt ein `.value`. Dort heißt es `tasks.value` und `newTask.value`, nur im Template ohne.
- **Das Feld bleibt nach dem Hinzufügen gefüllt:** Die Zeile, die `newTask` leert, fehlt, oder am `<input>` fehlt `v-model`.
- **Auch leere Aufgaben landen in der Liste:** Die Prüfung mit `if` steht hinter dem `push`, oder sie prüft den Text, bevor die Leerzeichen entfernt sind.

<!-- loesung -->

In den geschweiften Klammern des neuen Objekts steht `title` allein. Das ist eine Kurzform von `title: title`: Heißt die Variable genauso wie der Name im Objekt, genügt es, ihn einmal zu schreiben.

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
