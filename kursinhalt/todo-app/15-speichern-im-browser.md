---
title: Speichern im Browser
summary: Die App merkt sich deine Aufgaben, auch wenn du die Seite neu lädst oder den Browser schließt.
section: js
---

Nach jedem Neuladen sind wieder die drei Beispielaufgaben da. Das änderst du jetzt.

## Der Speicher des Browsers

**`localStorage`** ist ein kleiner Speicher, den der Browser für jede Website führt. Was dort liegt, übersteht das Neuladen und das Schließen des Browsers. Er merkt sich Texte unter einem Namen. Ein Beispiel, das nicht in die App gehört:

```js
localStorage.setItem('color', 'Blau')
const color = localStorage.getItem('color')
```

`setItem` legt einen Text unter einem Namen ab, `getItem` holt ihn wieder. Liegt unter dem Namen nichts, liefert `getItem` den Wert `null`, das heißt „nichts“.

Eine Liste ist kein Text. Dafür gibt es zwei Übersetzer: `JSON.stringify` macht aus einem Array oder Objekt einen Text, `JSON.parse` macht daraus wieder ein Array oder Objekt. Wieder nur ein Beispiel:

```js
const text = JSON.stringify(['Rot', 'Blau'])
const colors = JSON.parse(text)
```

## Bei jeder Änderung speichern

`watch` beobachtet ein Ref und ruft bei jeder Änderung eine Funktion auf. Schreib ans Ende des Script-Teils von `app/app.vue`:

```js
watch(tasks, () => {
  localStorage.setItem('tasks', JSON.stringify(tasks.value))
}, { deep: true })
```

In den Klammern stehen das beobachtete Ref, die Funktion und eine Einstellung. `deep: true` heißt, dass Vue auch in die Liste hineinschaut. So zählt nicht nur eine ausgetauschte Liste als Änderung, sondern auch eine neue Aufgabe oder ein umgedrehtes `done`. Auch `watch` stellt Nuxt von selbst bereit, genau wie `onMounted`, das gleich folgt.

Speichere und hake eine Aufgabe ab. Vom Speichern selbst siehst du auf der Seite nichts, wohl aber in den Entwicklerwerkzeugen: Öffne sie wie beim Feinschliff und such den Bereich für gespeicherte Daten. In Chrome und Edge heißt er „Application“, in Firefox „Web-Speicher“, bei dir vielleicht etwas anders. Unter „Local Storage“ und der Adresse deiner App steht ein Eintrag `tasks` mit deiner Liste als Text.

Lade die Seite neu. Trotzdem erscheinen wieder die Beispielaufgaben, denn gespeichert wird schon, geladen noch nicht.

## Laden, sobald die Seite im Browser ist

Naheliegend wäre, den Speicher gleich oben im Script-Teil auszulesen. Das scheitert. Nuxt baut die Seite zuerst auf dem Server zusammen, also in dem Programm, das in deinem Terminal läuft, und schickt sie fertig an den Browser. Der Server hat keinen Zugriff auf den Speicher deines Browsers, und die Seite bräche mit einem Fehler ab.

`onMounted` löst das. Es bekommt eine Funktion, und die läuft nur im Browser, sobald die Seite dort angezeigt wird. Ein Beispiel, das nicht in die App gehört:

```js
const message = ref('')

onMounted(() => {
  message.value = 'Jetzt bin ich im Browser'
})
```

Bei `watch` gibt es das Problem nicht: Seine Funktion läuft erst, wenn sich im Browser etwas ändert.

## Deine Aufgabe

1. Lade in `onMounted` den Text, der unter `tasks` gespeichert ist. Gibt es einen, wandle ihn zurück und weise ihn `tasks` zu.
2. Ersetze die drei Beispielaufgaben durch ein leeres Array, also zwei eckige Klammern ohne Inhalt.
3. Schreib die Funktion `clearTasks`, die die Liste leert, und verbinde sie mit dem Klick auf „Alle löschen“. Der Button ist nur zu sehen, wenn es mindestens eine Aufgabe gibt.

Tipp: Ob etwas gespeichert war, prüfst du mit `if` und dem geladenen Wert in den Klammern, ganz ohne Vergleich. `null` zählt als falsch, jeder gespeicherte Text als wahr. Für den Button kennst du `v-if`, `length` und „größer als“.

Wenn es geklappt hat, bleiben deine Aufgaben nach dem Neuladen stehen, samt Häkchen. Auch die drei Beispielaufgaben sind noch da: Sie kommen jetzt aus dem Speicher. Mit „Alle löschen“ wirst du sie los. Dann erscheint der Hinweis, und der Button verschwindet.

### Wenn es nicht klappt

- **Eine Fehlermeldung nennt `localStorage`:** Der Zugriff steht direkt im Script-Teil statt in der Funktion von `onMounted`.
- **Nach dem Neuladen ist die Liste leer:** Der Name in `getItem` ist anders geschrieben als der in `setItem`, oder die Zuweisung an `tasks.value` fehlt.
- **Neue Aufgaben und Häkchen werden erst gespeichert, wenn du eine Aufgabe löschst:** Bei `watch` fehlt `{ deep: true }`.

<!-- loesung -->

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
