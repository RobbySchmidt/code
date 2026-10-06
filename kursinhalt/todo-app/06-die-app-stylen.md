---
title: Die App stylen
summary: Mit Abständen, Farben, runden Ecken und Flex bekommt die App ihr Layout.
section: css
---

In dieser Lektion bekommt die App ihre Form: ein heller Hintergrund, darauf eine weiße Karte mit Formular und Liste.

## Hintergrund und Karte

Für die Karte brauchst du ein neues Tag. `<div>` ist ein Kasten ohne eigene Bedeutung. Man benutzt ihn, um mehrere Dinge zusammenzufassen und gemeinsam zu gestalten.

Gib `<main>` Klassen und lege direkt darin ein `<div>` um den gesamten bisherigen Inhalt. Vergiss das schließende `</div>` vor `</main>` nicht und rücke alles dazwischen um zwei Leerzeichen ein:

```vue
<main class="min-h-screen bg-slate-100 px-4 py-10">
  <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
    <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
    <p class="mt-1 text-sm text-slate-500">2 offen</p>
    …
  </div>
</main>
```

Die drei Punkte stehen für Formular, Liste und den letzten Button, die unverändert bleiben. Neu ist auch `mt-1` am Absatz.

Speichere. Die Seite ist jetzt hellgrau, und in der Mitte liegt eine weiße Karte mit runden Ecken.

## Was die Klassen bedeuten

**Abstände** gibt es in zwei Arten. Der Innenabstand ist der Platz zwischen dem Rand eines Kastens und seinem Inhalt, die Klassen beginnen mit `p` (englisch „padding“). Der Außenabstand ist der Platz zwischen einem Kasten und seinen Nachbarn, die Klassen beginnen mit `m` (englisch „margin“).

- `p-6` gibt Innenabstand auf allen Seiten. `px-4` wirkt nur links und rechts, `py-10` nur oben und unten.
- `mt-1` gibt Außenabstand nach oben (das „t“ steht für „top“). `mx-auto` verteilt den freien Platz links und rechts gleich und rückt die Karte damit in die Mitte.
- Die Zahl ist die Größe: Je größer sie ist, desto größer der Abstand. Eine Stufe entspricht vier Bildpunkten.

**Farben** kennst du schon von der Schrift. `bg-slate-100` färbt den Hintergrund (englisch „background“), `bg-white` macht ihn weiß.

**Größe und Form:** `min-h-screen` macht `<main>` mindestens so hoch wie das Fenster. `max-w-md` begrenzt die Breite der Karte. `rounded-2xl` rundet die Ecken, kleinere Stufen sind `rounded-xl` und `rounded-lg`. `shadow-sm` legt einen zarten Schatten unter die Karte.

## Rahmen

`border` zeichnet einen dünnen Rahmen um ein Tag. Die Farbe bestimmst du mit einer zweiten Klasse wie `border-slate-300`.

## Nebeneinander mit Flex

Normalerweise stehen Kästen untereinander. Die Klasse `flex` an einem äußeren Tag stellt alle Tags direkt darin nebeneinander in eine Zeile. Dazu passen:

- `gap-2` legt einen Abstand zwischen die Nachbarn.
- `items-center` richtet sie in der Höhe mittig aus.
- `flex-1` schreibst du an eines der inneren Tags. Es bekommt dann allen Platz, der in der Zeile übrig ist.

Ein Beispiel, das nicht in die App gehört:

```vue
<div class="flex items-center gap-2">
  <p>Links</p>
  <p class="flex-1">Ich bekomme den restlichen Platz</p>
  <p>Rechts</p>
</div>
```

Damit ein Stück Text eine eigene Klasse bekommen kann, braucht es ein eigenes Tag. Dafür gibt es `<span>`. Es ist wie `<div>` ohne eigene Bedeutung, umschließt aber nur ein Stück Text in einer Zeile.

## Deine Aufgabe

Style das Formular und die Listeneinträge. Eingabefeld und Button stehen nebeneinander, das Feld nimmt den freien Platz ein und hat einen Rahmen, der Button ist farbig mit weißer Schrift. Jeder Eintrag hat einen Rahmen mit runden Ecken, und der Text der Aufgabe füllt den Platz zwischen den beiden Buttons.

Tipps:

- Setze den Text jeder Aufgabe in ein `<span>`.
- Als Farbe passt `indigo-600`, ein kräftiges Blauviolett.
- Formular, Liste und „Alle löschen“ brauchen Abstand nach oben. Die Klasse `space-y-2` an `<ul>` legt Abstand zwischen die Einträge.
- Die kleinen Buttons wirken mit kleinerer, grauer Schrift ruhiger.
- Wird ein Tag mit vielen Klassen zu lang für eine Zeile, darfst du seine Attribute untereinander schreiben. So macht es auch die Musterlösung beim Eingabefeld.

Wenn es geklappt hat, füllt das Formular die Breite der Karte, und darunter stehen drei umrahmte Zeilen.

### Wenn es nicht klappt

- **Feld und Button stehen untereinander:** `flex` muss am `<form>` stehen, nicht am Eingabefeld.
- **Eine Klasse wirkt nicht:** Prüfe die Schreibweise und ob alle Klassen eines Tags in einem einzigen Attribut `class` stehen. Ein zweites `class` am selben Tag ist ein Fehler.
- **Der Rahmen fehlt:** `border-slate-200` allein legt nur die Farbe fest. Du brauchst zusätzlich `border`.

<!-- loesung -->

```vue [app/app.vue]
<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      <p class="mt-1 text-sm text-slate-500">2 offen</p>

      <form class="mt-6 flex gap-2">
        <input
          type="text"
          placeholder="Neue Aufgabe"
          class="flex-1 rounded-xl border border-slate-300 px-4 py-2 text-slate-900"
        >
        <button type="submit" class="rounded-xl bg-indigo-600 px-4 py-2 text-white">Hinzufügen</button>
      </form>

      <ul class="mt-6 space-y-2">
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button type="button" class="text-sm text-slate-500">Erledigt</button>
          <span class="flex-1 text-slate-900">Einkaufen gehen</span>
          <button type="button" class="text-sm text-slate-400">Löschen</button>
        </li>
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button type="button" class="text-sm text-slate-500">Erledigt</button>
          <span class="flex-1 text-slate-900">Wäsche waschen</span>
          <button type="button" class="text-sm text-slate-400">Löschen</button>
        </li>
        <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
          <button type="button" class="text-sm text-slate-500">Erledigt</button>
          <span class="flex-1 text-slate-900">Oma anrufen</span>
          <button type="button" class="text-sm text-slate-400">Löschen</button>
        </li>
      </ul>

      <button type="button" class="mt-6 text-sm text-slate-500">Alle löschen</button>
    </div>
  </main>
</template>
```
