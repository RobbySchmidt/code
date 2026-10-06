---
title: Aufgaben löschen
summary: Du lernst, wie man Einträge aus einer Liste aussortiert, und bringst den Papierkorb zum Laufen.
section: js
---

Hinzufügen und Abhaken funktionieren. Jetzt bekommt der Papierkorb seine Arbeit.

## Aussortieren mit `filter`

`filter` geht ein Array durch und baut ein neues Array aus allen Einträgen, für die eine Bedingung wahr ist. Die Bedingung schreibst du wie bei `find` als Funktion in Kurzform:

```js
const numbers = ref([4, 8, 15, 16, 23])

const big = numbers.value.filter(number => number > 10)
```

Das Zeichen `>` bedeutet „größer als“. `big` ist danach ein Array mit den drei Zahlen 15, 16 und 23.

Der Unterschied zu `find`: `find` liefert einen einzelnen Eintrag, `filter` immer ein Array. Passt kein Eintrag, ist es leer.

Für Bedingungen gibt es mehrere Vergleiche:

- `>` ist wahr, wenn der linke Wert größer ist, `<`, wenn er kleiner ist.
- `===` ist wahr, wenn beide Werte gleich sind.
- `!==` ist wahr, wenn sie verschieden sind. Das Ausrufezeichen steht auch hier für „nicht“.

## Das Ergebnis zuweisen

Wichtig ist, was im Beispiel nicht passiert: `numbers` selbst bleibt, wie es war, mit allen fünf Zahlen. `filter` verändert die Liste nicht, es liefert eine neue.

Sollen die kleinen Zahlen wirklich verschwinden, musst du der Liste das Ergebnis neu zuweisen:

```js
numbers.value = numbers.value.filter(number => number > 10)
```

JavaScript rechnet zuerst aus, was rechts vom Gleichheitszeichen steht. Das Ergebnis legt es dann unter dem alten Namen ab und ersetzt damit die alte Liste. Weil `numbers` ein Ref ist, bemerkt Vue den Wechsel und zeichnet die Seite neu.

Das ist anders als bei `push` aus der Lektion über das Hinzufügen. `push` verändert die vorhandene Liste, darum brauchtest du dort keine Zuweisung. `filter` lässt sie in Ruhe. Die Zuweisung zu vergessen ist der häufigste Fehler in dieser Lektion.

Löschen heißt für JavaScript hier also: Behalte alle außer einem.

## Deine Aufgabe

Schreib die Funktion `deleteTask`. Sie bekommt eine `id` und entfernt die Aufgabe mit dieser `id` aus `tasks`. Verbinde sie mit dem Klick auf den Papierkorb eines Eintrags.

Tipp: Dreh die Frage um. Überlege nicht, welche Aufgabe weg soll, sondern welche bleiben sollen: alle, deren `id` eine andere ist als die übergebene. Den Klick verbindest du so, wie du es beim Kreis getan hast.

Wenn es geklappt hat, verschwindet ein Eintrag, sobald du auf seinen Papierkorb klickst. Die anderen bleiben stehen. Lösch ruhig alle drei: Nach dem Neuladen der Seite sind die Beispielaufgaben wieder da.

Die Zahl über der Liste stimmt jetzt nicht mehr, dort steht weiter „2 offen“. Darum kümmerst du dich in der nächsten Lektion.

### Wenn es nicht klappt

- **Der Klick bewirkt nichts:** Das Ergebnis von `filter` wird nicht zugewiesen. Vorn muss `tasks.value =` stehen. Oder im Aufruf am Button fehlt `task.id` in den Klammern.
- **Die angeklickte Aufgabe bleibt, alle anderen verschwinden:** In der Bedingung steht `===` statt `!==`.
- **Ein Klick auf den Kreis löscht die Aufgabe:** `@click` mit `deleteTask` steht am falschen Button. Es gehört an den mit dem Papierkorb.
- **Eine Meldung sagt, `filter` sei keine Funktion:** Es fehlt `.value` hinter `tasks`.

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

function deleteTask(id) {
  tasks.value = tasks.value.filter(task => task.id !== id)
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
            @click="deleteTask(task.id)"
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
