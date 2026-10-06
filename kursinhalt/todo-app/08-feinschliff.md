---
title: Feinschliff
summary: Die App reagiert auf Maus und Tastatur, passt aufs Handy und zeigt erledigte Aufgaben.
section: css
---

Die App sieht schon gut aus. Jetzt kommen die Kleinigkeiten, die sie fertig wirken lassen.

## Klassen, die nur manchmal gelten

Bisher gilt jede Klasse immer. Mit einem Wort und einem Doppelpunkt davor gilt sie nur in einer bestimmten Lage. `hover:` heißt: nur solange der Mauszeiger auf dem Tag steht.

Ergänze am Button mit dem Plus die Klassen ab `transition-colors`. Neu ist außerdem `shrink-0`, dazu gleich mehr:

```vue
<button
  type="submit"
  aria-label="Aufgabe hinzufügen"
  class="flex size-10 shrink-0 items-center justify-center rounded-xl bg-indigo-600 text-white transition-colors hover:bg-indigo-700 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
>
  <Plus class="size-5" />
</button>
```

Speichere und fahre mit der Maus über den Button. Er wird etwas dunkler.

- `hover:bg-indigo-700` setzt den dunkleren Hintergrund, solange die Maus darauf steht.
- `transition-colors` lässt Farben weich wechseln statt schlagartig.
- `focus-visible:` gilt, wenn jemand den Button mit der Tastatur ansteuert. Die drei Klassen zeichnen dann einen Ring: `outline-2` ist seine Dicke, `outline-offset-2` sein Abstand zum Button, `outline-indigo-600` seine Farbe.

Probier es aus: Klicke in das Eingabefeld und drücke die Tabulatortaste. Um den Button erscheint ein Ring. Wer ohne Maus arbeitet, sieht so, wo er gerade ist.

## Das Eingabefeld

Auch das Eingabefeld bekommt solche Klassen. Ergänze sein `class` so:

```vue
class="min-w-0 flex-1 rounded-xl border border-slate-300 px-4 py-2 text-slate-900 placeholder:text-slate-400 focus:border-indigo-600 focus:outline-none"
```

`placeholder:` gilt für den Hinweistext, er wird heller. `focus:` gilt, sobald das Feld ausgewählt ist, egal ob mit Maus oder Tastatur. `focus:outline-none` entfernt den Ring, den der Browser von sich aus zeichnet, und `focus:border-indigo-600` färbt dafür den Rahmen.

Klicke in das Feld: Der Rahmen wird blauviolett.

## Die Ansicht am Handy

Viele Menschen öffnen Webseiten am Handy. Wie deine App dort aussieht, prüfst du am Rechner: Öffne im Browser die Entwicklerwerkzeuge mit F12, auf dem Mac mit Cmd+Option+I. Dort gibt es einen Knopf mit einem Handy-Symbol, der die Seite schmal wie auf einem Handy anzeigt. Noch einfacher: Zieh das Browserfenster so schmal wie möglich.

Die Karte passt sich an. Eng wird es erst bei langen Texten. Dafür gibt es drei Klassen:

- `shrink-0` verbietet einem Tag in einer Flex-Zeile, schmaler zu werden. So bleibt ein Button immer ganz.
- `min-w-0` erlaubt einem Tag in einer Flex-Zeile, schmaler zu werden als sein Inhalt. So ragt nichts aus der Karte.
- `break-words` bricht auch ein sehr langes Wort in die nächste Zeile um.

Schließe die Entwicklerwerkzeuge danach wieder mit F12.

## Erledigt

Über der Liste steht „2 offen“ bei drei Aufgaben. Eine ist also erledigt, und das soll man sehen. Die Klasse `line-through` streicht einen Text durch.

## Deine Aufgabe

1. Die Papierkörbe und „Alle löschen“ werden rot (`red-600`), wenn die Maus darauf steht, mit weichem Übergang.
2. Die Kreise und die Papierkörbe in der Liste bekommen denselben Tastatur-Ring wie der Button mit dem Plus. Ein offener Kreis bekommt unter der Maus einen blauvioletten Rahmen.
3. Die Kreise dürfen nicht schmaler werden, und ein langer Aufgabentext soll umbrechen, statt aus der Karte zu ragen.
4. Gestalte die erste Aufgabe als erledigt: Der Text ist heller grau und durchgestrichen, der Kreis blauviolett gefüllt mit einem weißen Häkchen. Ihr Kreis heißt jetzt „Als offen markieren“.

Wenn es geklappt hat, sieht die erste Aufgabe abgehakt aus. Ersetze zum Testen einen Aufgabentext durch einen sehr langen und prüfe die schmale Ansicht.

### Wenn es nicht klappt

- **Der Hover wirkt nicht:** Zwischen `hover:` und der Klasse darf kein Leerzeichen stehen. Richtig ist `hover:text-red-600`.
- **Der Kreis der erledigten Aufgabe ist gefüllt, aber leer:** Dort steht noch `text-transparent`. Ersetze es durch `text-white`.
- **Zwei Farben streiten sich:** Stehen an einem Tag zwei Klassen für dieselbe Sache, etwa `border-slate-300` und `border-indigo-600`, gewinnt nicht unbedingt die letzte. Lösche die, die du nicht willst.
- **Der Ring erscheint beim Klicken mit der Maus nicht:** Das soll so sein. `focus-visible:` reagiert bei Buttons nur auf die Tastatur.

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
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button
            type="button"
            aria-label="Als offen markieren"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 border-indigo-600 bg-indigo-600 text-white"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words text-slate-400 line-through">Einkaufen gehen</span>
          <button
            type="button"
            aria-label="Aufgabe löschen"
            class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            <Trash2 class="size-4" />
          </button>
        </li>
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 border-slate-300 text-transparent hover:border-indigo-600"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words text-slate-900">Wäsche waschen</span>
          <button
            type="button"
            aria-label="Aufgabe löschen"
            class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            <Trash2 class="size-4" />
          </button>
        </li>
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 border-slate-300 text-transparent hover:border-indigo-600"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words text-slate-900">Oma anrufen</span>
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
