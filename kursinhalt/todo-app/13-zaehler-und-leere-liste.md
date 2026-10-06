---
title: Zähler und leere Liste
summary: Die App zählt ihre offenen Aufgaben selbst und zeigt einen Hinweis, wenn die Liste leer ist.
section: js
---

Zwei Stellen der App stimmen noch nicht. Über der Liste steht immer „2 offen“, egal wie viele Aufgaben offen sind. Und wenn du alle Aufgaben löschst, bleibt eine leere Fläche zurück.

## Anzeigen unter einer Bedingung

Das Attribut `v-if` zeigt ein Tag nur dann an, wenn eine Bedingung wahr ist. Bekommt das direkt folgende Tag `v-else`, erscheint es genau dann, wenn die Bedingung falsch ist. Von den beiden ist also immer eines zu sehen.

Für die Bedingung brauchst du `length`. Es liefert die Anzahl der Einträge eines Arrays.

Setze direkt über das `<ul>` einen Absatz:

```vue
<p v-if="tasks.length === 0" class="mt-6 text-center text-slate-500">
  Noch keine Aufgaben. Leg los!
</p>
```

Ergänze dann am `<ul>` als erstes Attribut `v-else`:

```vue
<ul v-else class="mt-6 space-y-2">
```

Die Klasse `text-center` rückt den Text in die Mitte.

Speichere. Zunächst sieht alles aus wie vorher, denn die Liste hat drei Einträge. Lösche alle drei mit dem Papierkorb: Statt der Liste erscheint der Hinweis „Noch keine Aufgaben. Leg los!“. Füge eine Aufgabe hinzu, und der Hinweis macht der Liste wieder Platz.

Zwischen dem Tag mit `v-if` und dem mit `v-else` darf kein anderes Tag stehen.

## Werte, die sich selbst berechnen

Die Zahl der offenen Aufgaben ist kein eigener Wert, den du pflegen musst. Sie ergibt sich aus der Liste. Für solche Fälle gibt es `computed`. Ein **berechneter Wert** entsteht aus anderen Werten, und Vue hält ihn von selbst aktuell. Ein Beispiel, das nicht in die App gehört:

```vue
<script setup>
const price = ref(4)
const amount = ref(3)

const total = computed(() => price.value * amount.value)
</script>

<template>
  <p>Summe: {{ total }}</p>
</template>
```

In den Klammern von `computed` steht wieder eine Funktion in Kurzform. Sie braucht keinen Eintrag zum Prüfen, darum bleiben die runden Klammern vor dem Pfeil leer. Hinter dem Pfeil steht die Rechnung, das Sternchen bedeutet „mal“.

Die Seite zeigt „Summe: 12“. Bekommt `amount` später den Wert 5, steht dort ohne dein Zutun „Summe: 20“.

## Der Unterschied zu einer Funktion

Eine Funktion läuft nur, wenn sie aufgerufen wird. Für die Summe müsstest du also an jeder Stelle, die Preis oder Menge ändert, daran denken, neu zu rechnen.

Einen berechneten Wert schreibst du einmal hin. Vue merkt sich, welche Refs in der Rechnung vorkommen, und rechnet neu, sobald sich einer davon ändert. Benutzt wird er wie eine Variable: im Template nur mit dem Namen, im Script-Teil mit `.value`.

Auch `computed` stellt Nuxt von selbst bereit.

## Deine Aufgabe

Lege `openCount` als berechneten Wert an: die Anzahl der Aufgaben, die nicht erledigt sind. Zeige ihn über der Liste an, anstelle der festen 2 in „2 offen“.

Tipp: `filter` aus der letzten Lektion liefert dir alle offenen Aufgaben, `length` ihre Anzahl. Wie du aus „erledigt“ ein „nicht erledigt“ machst, weißt du seit dem Abhaken.

Wenn es geklappt hat, steht nach dem Laden weiter „2 offen“ da. Hakst du eine Aufgabe ab, wird daraus „1 offen“. Fügst du eine hinzu, steigt die Zahl, und löschst du eine offene, sinkt sie.

### Wenn es nicht klappt

- **Statt einer Zahl steht ein Stück Programm auf der Seite:** `computed` fehlt, und `openCount` ist nur eine Funktion. Die Kurzform gehört in die Klammern von `computed`.
- **Eine Meldung sagt, `filter` sei keine Funktion:** In der Rechnung fehlt `.value` hinter `tasks`.
- **Die Zahl zählt die erledigten Aufgaben:** In der Bedingung fehlt das Ausrufezeichen vor `task.done`.
- **Der Browser meldet einen Fehler zu `v-else`:** Zwischen dem Absatz mit `v-if` und dem `<ul>` steht ein anderes Tag.

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
