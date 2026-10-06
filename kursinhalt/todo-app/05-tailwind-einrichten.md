---
title: Tailwind einrichten
summary: Du richtest Tailwind ein und gibst der Überschrift mit Klassen ein neues Aussehen.
section: css
---

Das Gerüst steht. Jetzt beginnt der zweite Durchgang: das Aussehen.

## CSS und Tailwind

**CSS** ist die Sprache, mit der man festlegt, wie eine Seite aussieht: Farben, Schriftgrößen, Abstände. Üblicherweise schreibt man dafür Regeln in eine eigene Datei und muss sich für jede Regel einen Namen ausdenken.

**Tailwind** ist ein Baustein, der dir diese Arbeit abnimmt. Er bringt viele kleine, fertige Klassen mit. Eine **Klasse** ist ein Name, den du an ein Tag schreibst und an dem eine Gestaltungsregel hängt. Jede Tailwind-Klasse tut genau eine Sache, zum Beispiel „Schrift fett“. Du schreibst die Klassen direkt an das Tag und siehst sofort, wie es aussieht.

## Tailwind installieren

Stoppe den Entwicklungsserver im Terminal mit Strg+C, auf dem Mac mit Control+C. Installiere dann zwei Bausteine:

```bash
npm install tailwindcss @tailwindcss/vite
```

Nach einem Moment meldet npm, dass Pakete hinzugefügt wurden („added“).

## Tailwind einschalten

Nuxt muss noch erfahren, dass es Tailwind benutzen soll. Dafür änderst du zwei Dateien.

Öffne `nuxt.config.ts` und ersetze den Inhalt durch:

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

Neu sind die erste Zeile, die Zeile mit `css` und der Block `vite`. Sie holen Tailwind ins Projekt und nennen die CSS-Datei, die gleich entsteht. Die Endung `.ts` steht für **TypeScript**, eine Variante von JavaScript. Die Datei heißt bei Nuxt immer so. TypeScript lernen musst du dafür nicht.

Lege jetzt die CSS-Datei an. Klicke in VS Code mit der rechten Maustaste auf den Ordner `app`, wähle „New File“ („Neue Datei“) und tippe als Namen `assets/css/main.css`. VS Code legt die beiden Ordner gleich mit an. In die Datei kommt eine einzige Zeile:

```css [app/assets/css/main.css]
@import "tailwindcss";
```

Speichere beide Dateien und starte den Server wieder mit `npm run dev`. Lade die Seite im Browser neu, falls sie sich nicht von selbst aktualisiert.

Im Browser sieht die Seite jetzt schlichter aus als vorher: Die Überschrift ist so klein wie normaler Text, Eingabefeld und Buttons haben keinen Rahmen mehr, die Punkte vor den Einträgen fehlen. Das ist das Zeichen, dass Tailwind läuft. Es räumt das Aussehen, das der Browser von sich aus mitbringt, erst einmal weg, damit du alles selbst bestimmen kannst.

## Die ersten Klassen

Klassen schreibst du in das Attribut `class`, mehrere hintereinander mit Leerzeichen getrennt. Ändere in `app/app.vue` die Zeile mit der Überschrift:

```vue
<h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
```

Speichere. Die Überschrift ist wieder groß und fett. Die drei Klassen bedeuten:

- `text-2xl` bestimmt die Schriftgröße. Die Stufen heißen von klein nach groß `text-xs`, `text-sm`, `text-base`, `text-lg`, `text-xl`, `text-2xl` und so weiter. `text-base` ist die normale Größe.
- `font-bold` macht die Schrift fett.
- `text-slate-900` bestimmt die Schriftfarbe. `slate` ist ein leicht bläuliches Grau. Die Zahl dahinter ist die Helligkeit: `50` ist fast weiß, `500` ein mittleres Grau, `950` fast schwarz.

Verändere zum Ausprobieren die Zahl oder die Größe und speichere. Stell danach wieder die Klassen von oben ein.

## Deine Aufgabe

Gib dem Absatz „2 offen“ unter der Überschrift eine kleinere Schrift als normal und ein mittleres Grau als Farbe.

Wenn es geklappt hat, steht „2 offen“ klein und grau unter der dunklen, fetten Überschrift.

### Wenn es nicht klappt

- **Die Klassen bewirken nichts, und die Seite sieht aus wie vor dieser Lektion:** Tailwind ist nicht eingeschaltet. Vergleiche `nuxt.config.ts` Zeichen für Zeichen mit der Vorlage und prüfe, ob `main.css` wirklich im Ordner `app/assets/css` liegt.
- **Das Terminal meldet, dass `@tailwindcss/vite` nicht gefunden wird:** Die Installation fehlt oder lief im falschen Ordner. Führe den Befehl `npm install` von oben noch einmal im Ordner `todo-app` aus.
- **Nur eine einzelne Klasse wirkt nicht:** Meist ist es ein Tippfehler. Tailwind kennt `text-slate-500`, aber nicht `text-slate500`. Eine falsch geschriebene Klasse erzeugt keine Fehlermeldung, sie tut einfach nichts.
- **Das Terminal meldet einen Fehler in `nuxt.config.ts`:** Prüfe Kommas und Klammern. Hinter jeder Zeile im Block steht ein Komma, außer hinter der letzten.

<!-- loesung -->

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

```css [app/assets/css/main.css]
@import "tailwindcss";
```

```vue [app/app.vue]
<template>
  <main>
    <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
    <p class="text-sm text-slate-500">2 offen</p>

    <form>
      <input type="text" placeholder="Neue Aufgabe">
      <button type="submit">Hinzufügen</button>
    </form>

    <ul>
      <li>
        <button type="button">Erledigt</button>
        Einkaufen gehen
        <button type="button">Löschen</button>
      </li>
      <li>
        <button type="button">Erledigt</button>
        Wäsche waschen
        <button type="button">Löschen</button>
      </li>
      <li>
        <button type="button">Erledigt</button>
        Oma anrufen
        <button type="button">Löschen</button>
      </li>
    </ul>

    <button type="button">Alle löschen</button>
  </main>
</template>
```
