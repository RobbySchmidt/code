---
title: Icons mit Lucide
summary: Du installierst eine Icon-Sammlung und ersetzt die Texte der Buttons durch Icons.
section: css
---

Buttons mit Wörtern brauchen viel Platz. Ein **Icon** ist ein kleines Bildsymbol, das dasselbe sagt, zum Beispiel ein Papierkorb für „Löschen“.

## Lucide installieren

**Lucide** ist eine kostenlose Sammlung von über tausend Icons. Stoppe den Entwicklungsserver mit Strg+C, auf dem Mac mit Control+C, und installiere sie:

```bash
npm install @lucide/vue
```

npm meldet wieder, dass ein Paket hinzugefügt wurde. Starte den Server danach mit `npm run dev`.

## Ein Icon holen und benutzen

Bevor du ein Icon verwenden kannst, musst du es in die Datei holen. Das geschieht in einem neuen Teil von `app/app.vue`, der über dem Template steht: `<script setup>`. Dorthin gehört JavaScript. Im Moment ist das eine einzige Zeile, ein **Import**. Er holt etwas aus einem installierten Baustein in deine Datei.

Im Template benutzt du das Icon dann wie ein Tag. Ergänze den Script-Teil und fasse Icon und Überschrift in einem `<div>` zusammen:

```vue
<script setup>
import { ListTodo } from '@lucide/vue'
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      …
```

Der Rest des Templates bleibt, wie er ist.

Speichere. Links neben der Überschrift siehst du jetzt eine kleine blauviolette Liste mit Häkchen.

Dazu vier Hinweise:

- Der Name in den geschweiften Klammern und der Name des Tags müssen genau gleich sein, auch in Groß- und Kleinschreibung.
- Ein Icon hat keinen Inhalt und schließt sich deshalb mit `/>` selbst.
- `size-7` legt Breite und Höhe auf einmal fest. Die Zahlen sind dieselben Stufen wie bei den Abständen.
- Ein Icon nimmt die Schriftfarbe an. Mit `text-indigo-600` färbst du es also wie einen Text.

Brauchst du mehrere Icons, schreibst du ihre Namen mit Kommas getrennt in die geschweiften Klammern. Alle Icons findest du auf `https://lucide.dev/icons`. Die Namen stehen dort klein und mit Bindestrich, zum Beispiel `list-todo`. In deinem Code schreibst du sie ohne Bindestrich und jeden Wortanfang groß: `ListTodo`.

## Buttons ohne Text

Manche Menschen lassen sich Webseiten von einem Programm vorlesen, weil sie den Bildschirm nicht sehen. Bei einem Button, der nur ein Icon enthält, wüsste es nicht, was es vorlesen soll.

Dafür gibt es das Attribut `aria-label`. Sein Wert ist ein Text, der nicht angezeigt, aber vorgelesen wird. Auch das Eingabefeld braucht einen solchen Namen, denn auf den grauen Hinweistext ist dafür nicht überall Verlass. Ergänze dort:

```vue
aria-label="Neue Aufgabe"
```

Im Browser siehst du davon nichts.

## Drei Klassen für Icon-Buttons

- `justify-center` gehört zu `flex` und rückt den Inhalt waagerecht in die Mitte. Zusammen mit `items-center` sitzt ein Icon damit genau mittig im Button.
- `rounded-full` rundet die Ecken so stark, dass aus einem Quadrat ein Kreis wird.
- `text-transparent` macht die Schriftfarbe durchsichtig. Ein Icon mit dieser Farbe ist da, aber unsichtbar.

## Deine Aufgabe

Stelle die Buttons auf Icons um. Du brauchst dafür `Plus`, `Check` und `Trash2`.

- „Hinzufügen“ wird ein quadratischer Button, in dessen Mitte ein Plus sitzt.
- „Erledigt“ wird ein kleiner Kreis mit grauem Rahmen, in dessen Mitte ein Häkchen sitzt. Weil die Aufgabe noch offen ist, soll das Häkchen unsichtbar sein.
- „Löschen“ wird ein grauer Papierkorb.
- „Alle löschen“ behält seinen Text und bekommt einen kleinen Papierkorb davor.

Gib den drei Buttons ohne Text die Namen „Aufgabe hinzufügen“, „Als erledigt markieren“ und „Aufgabe löschen“.

Tipp: Eine feste Größe bekommt ein Button mit `size-` und einer Zahl. Den Innenabstand braucht er dann nicht mehr.

Wenn es geklappt hat, steht neben dem Eingabefeld ein Quadrat mit weißem Plus, und jeder Eintrag beginnt mit einem leeren Kreis und endet mit einem Papierkorb.

### Wenn es nicht klappt

- **Ein Icon erscheint nicht:** Das Icon wird im Template benutzt, steht aber nicht im Import, oder der Name ist anders geschrieben. `Trash2` ist nicht dasselbe wie `trash2`.
- **Der Browser zeigt eine Fehlermeldung:** Prüfe, ob jedes Icon mit `/>` endet und ob `<script setup>` mit `</script>` geschlossen ist.
- **Das Icon klebt oben links im Button:** Dem Button fehlt `flex` zusammen mit `items-center` und `justify-center`.

<!-- loesung -->

```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'
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
          class="flex-1 rounded-xl border border-slate-300 px-4 py-2 text-slate-900"
        >
        <button
          type="submit"
          aria-label="Aufgabe hinzufügen"
          class="flex size-10 items-center justify-center rounded-xl bg-indigo-600 text-white"
        >
          <Plus class="size-5" />
        </button>
      </form>

      <ul class="mt-6 space-y-2">
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 items-center justify-center rounded-full border border-slate-300 text-transparent"
          >
            <Check class="size-4" />
          </button>
          <span class="flex-1 text-slate-900">Einkaufen gehen</span>
          <button type="button" aria-label="Aufgabe löschen" class="text-slate-400">
            <Trash2 class="size-4" />
          </button>
        </li>
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 items-center justify-center rounded-full border border-slate-300 text-transparent"
          >
            <Check class="size-4" />
          </button>
          <span class="flex-1 text-slate-900">Wäsche waschen</span>
          <button type="button" aria-label="Aufgabe löschen" class="text-slate-400">
            <Trash2 class="size-4" />
          </button>
        </li>
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 items-center justify-center rounded-full border border-slate-300 text-transparent"
          >
            <Check class="size-4" />
          </button>
          <span class="flex-1 text-slate-900">Oma anrufen</span>
          <button type="button" aria-label="Aufgabe löschen" class="text-slate-400">
            <Trash2 class="size-4" />
          </button>
        </li>
      </ul>

      <button type="button" class="mt-6 flex items-center gap-2 text-sm text-slate-500">
        <Trash2 class="size-4" />
        Alle löschen
      </button>
    </div>
  </main>
</template>
```
