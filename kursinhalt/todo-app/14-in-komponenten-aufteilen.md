---
title: In Komponenten aufteilen
summary: Du lagerst den Listeneintrag in eine eigene Datei aus und lässt beide Dateien miteinander sprechen.
section: js
---

`app/app.vue` ist lang geworden. Eine **Komponente** ist ein Stück Seite in einer eigenen Vue-Datei, das du wie ein Tag benutzt. Du kennst das schon von den Icons. Jede Datei hat dann eine einzige Aufgabe, und du findest schneller, was du suchst.

## Eine eigene Komponente

Klicke in VS Code mit der rechten Maustaste auf den Ordner `app`, wähle „New File“ („Neue Datei“) und tippe `components/TaskItem.vue`. In die Datei kommt:

```vue [app/components/TaskItem.vue]
<script setup>
defineProps({
  task: { type: Object, required: true }
})
</script>

<template>
  <li>{{ task.title }}</li>
</template>
```

Ein **Prop** ist ein Wert, den eine Komponente von außen bekommt, geschrieben wie ein Attribut. `defineProps` zählt die Props auf. Hier ist es eines: Es heißt `task`, muss ein Objekt sein und darf nicht fehlen.

Setze jetzt in `app/app.vue` direkt über das `<li>` diese Zeile:

```vue
<TaskItem v-for="task in tasks" :key="task.id" :task="task" />
```

`:task="task"` reicht die jeweilige Aufgabe in die Komponente hinein. Einen Import brauchst du nicht: Nuxt stellt jede Datei aus `app/components` unter ihrem Dateinamen bereit.

Speichere beide Dateien. Über den drei Einträgen stehen ihre Titel noch einmal als schlichter Text. Die Komponente funktioniert.

## Nach oben melden

Die Liste `tasks` und die Funktionen dazu bleiben in `app/app.vue`. Die Komponente kennt sie nicht und ändert auch nichts selbst. Sie meldet nur, was passiert ist. Ein **Event** ist eine Nachricht, die eine Komponente nach oben schickt.

Ein Beispiel, das nicht in die App gehört, eine Komponente `ColorButton.vue`:

```vue
<script setup>
defineEmits(['choose'])
</script>

<template>
  <button type="button" @click="$emit('choose', 'Rot')">Rot</button>
</template>
```

`defineEmits` zählt die Namen der Events auf, die die Komponente schicken kann. `$emit` schickt eines ab: zuerst der Name, danach ein Wert, der mitreist.

Wer die Komponente benutzt, hört auf das Event wie auf einen Klick:

```vue
<ColorButton @choose="setColor" />
```

Steht hinter dem Event nur der Name einer Funktion, bekommt sie den mitgeschickten Wert als Argument. `setColor` wird hier also mit „Rot“ aufgerufen.

## Deine Aufgabe

Stelle `TaskItem` fertig. Verschiebe das ganze `<li>` mit Kreis, Text und Papierkorb aus `app/app.vue` in die Komponente. Dort melden die beiden Buttons ihre Klicks mit den Events `check` und `delete` und schicken jeweils die `id` der Aufgabe mit. In `app/app.vue` verbindest du die Events mit `checkTask` und `deleteTask`.

Tipps:

- Ausschneiden und Einfügen spart Tipparbeit. In der Komponente ersetzt das verschobene `<li>` das bisherige.
- `v-for` und `:key` gehören in `app/app.vue` an `<TaskItem>`. Am `<li>` in der Komponente löschst du sie.
- Jede Datei importiert die Icons, die in ihrem eigenen Template vorkommen. Prüfe beide Importe.
- Bei vielen Attributen darfst du sie auch an `<TaskItem>` untereinander schreiben.

Wenn es geklappt hat, sieht die App genauso aus wie vor dieser Lektion, und Abhaken und Löschen funktionieren wie bisher. Nur `app/app.vue` ist deutlich kürzer.

### Wenn es nicht klappt

- **Die Kreise sind leer, oder die Papierkörbe fehlen:** In `TaskItem.vue` fehlt der Import der Icons.
- **Die Klicks bewirken nichts:** Der Name des Events muss an drei Stellen gleich geschrieben sein: in `defineEmits`, in `$emit` und hinter dem `@` in `app/app.vue`. Oder es fehlt `task.id` als zweiter Wert in `$emit`.
- **Die Liste bleibt leer, und eine Meldung sagt, `TaskItem` sei nicht bekannt:** Die Datei liegt nicht in `app/components` oder heißt anders. Stimmt beides, stoppe den Entwicklungsserver und starte ihn neu.
- **Eine Meldung nennt `checkTask`:** Die Komponente ruft die Funktion noch direkt auf. Sie kennt nur ihr Prop und ihre Events.

<!-- loesung -->

```vue [app/components/TaskItem.vue]
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

```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Trash2 } from '@lucide/vue'

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
        <TaskItem
          v-for="task in tasks"
          :key="task.id"
          :task="task"
          @check="checkTask"
          @delete="deleteTask"
        />
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
