---
title: Geschafft
summary: Ein Rückblick auf alles, was du gebaut hast, fünf Ideen zum Weitermachen und der vollständige Code.
section: abschluss
---

Deine Aufgabenliste ist fertig. Du hast sie Zeile für Zeile selbst gebaut, und sie läuft auf deinem eigenen Rechner. Schau kurz zurück, was dabei alles zusammengekommen ist.

## Was du gelernt hast

Mit **HTML** hast du beschrieben, was auf der Seite steht. Du kennst Tags und Attribute, hast ein Formular mit Eingabefeld und Button gebaut und eine Liste mit Einträgen. Du weißt, dass Tags ineinander stecken und dass ein vergessenes schließendes Tag die häufigste Fehlerquelle ist.

Mit **CSS** hast du der Seite ihr Aussehen gegeben. Dank Tailwind brauchtest du dafür keine eigene Datei voller Regeln, sondern kleine Klassen direkt am Tag: für Farben, Abstände, runde Ecken und das Nebeneinander mit Flex. Dazu kamen Icons, der Zustand unter der Maus, der Ring für die Tastatur und eine Ansicht, die auch am Handy passt.

Mit **JavaScript** hast du die Seite zum Leben erweckt. Die Aufgaben sind Daten in einem Ref, das Template zeigt sie an, und Funktionen ändern sie: hinzufügen, abhaken, löschen. Ein berechneter Wert zählt mit, eine Komponente hält den Code übersichtlich, und der Speicher des Browsers merkt sich alles. Das sind dieselben Bausteine, aus denen auch große Web-Apps bestehen.

## Ideen zum Weitermachen

Am meisten lernst du jetzt, wenn du die App nach deinen eigenen Wünschen umbaust. Fünf Vorschläge, vom leichten zum schweren:

1. **Ein eigenes Farbschema.** Ersetze überall `indigo` durch eine andere Farbe von Tailwind, zum Beispiel `emerald` oder `rose`, und probiere einen anderen Hintergrund aus.
2. **Ein Filter für offene und erledigte Aufgaben.** Drei Buttons „Alle“, „Offen“ und „Erledigt“ setzen ein Ref, und ein berechneter Wert liefert mit `filter` die passende Liste für das `v-for`.
3. **Ein Fälligkeitsdatum.** Ein `<input>` mit `type="date"` liefert ein Datum, das du als weiteren Wert im Objekt der Aufgabe ablegst und im Eintrag anzeigst.
4. **Aufgaben bearbeiten.** Ein Klick auf den Text macht aus ihm ein Eingabefeld mit `v-model`, und die Eingabetaste übernimmt die Änderung. Dafür braucht `TaskItem` ein drittes Event.
5. **Die App veröffentlichen.** Bisher läuft sie nur auf deinem Rechner. Es gibt Anbieter, bei denen kleine Projekte kostenlos im Internet stehen dürfen. Die Anleitung von Nuxt auf `https://nuxt.com` beschreibt unter dem Stichwort „Deployment“, wie das geht.

Wenn etwas nicht klappt, geh vor wie im Kurs: eine kleine Änderung, speichern, im Browser nachsehen. Und wenn du dich verrennst, hilft dir der Code unten zurück auf einen Stand, der funktioniert.

## Der vollständige Code

Das sind alle vier Dateien, die du im Kurs geschrieben oder geändert hast, im Stand nach der letzten Lektion. Alles andere im Projektordner hat Nuxt beim Anlegen selbst erzeugt.

Die Einstellungen für Nuxt:

```ts [nuxt.config.ts]
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

Die CSS-Datei, die Tailwind einschaltet:

```css [app/assets/css/main.css]
@import "tailwindcss";
```

Die Seite mit den Daten und den Funktionen:

```vue [app/app.vue]
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

Die Komponente für einen einzelnen Eintrag:

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
