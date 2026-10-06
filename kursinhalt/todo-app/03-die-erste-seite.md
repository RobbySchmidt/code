---
title: Die erste Seite
summary: Du schreibst dein erstes HTML und siehst es sofort im Browser.
section: html
---

Jetzt ersetzt du die Willkommensseite von Nuxt durch deine eigene Seite. Sorge dafür, dass der Entwicklungsserver läuft (`npm run dev`) und die App im Browser offen ist. Stell Browser und VS Code am besten nebeneinander.

## Das Template

Öffne in VS Code die Datei `app/app.vue`. Alles, was auf der Seite erscheinen soll, steht zwischen `<template>` und `</template>`.

Das **Template** ist der Teil einer `.vue`-Datei, der beschreibt, was auf der Seite zu sehen ist. Geschrieben wird es in HTML, der Sprache für den Inhalt von Webseiten.

## Tags

HTML besteht aus Tags. Ein **Tag** ist ein Wort in spitzen Klammern, das dem Browser sagt, was für eine Art von Inhalt jetzt kommt.

Die meisten Tags treten als Paar auf: Ein öffnendes Tag steht vor dem Inhalt, ein schließendes dahinter. Das schließende Tag erkennst du am Schrägstrich nach der ersten Klammer.

Das Tag `<h1>` steht für die wichtigste Überschrift einer Seite. Das „h“ kommt vom englischen „heading“. Lösche den ganzen Inhalt von `app/app.vue` und schreib stattdessen:

```vue [app/app.vue]
<template>
  <h1>Meine Aufgaben</h1>
</template>
```

Hier siehst du gleich zwei Paare. `<h1>` und `</h1>` umschließen den Text der Überschrift. `<template>` und `</template>` umschließen alles zusammen.

Die Überschrift ist um zwei Leerzeichen eingerückt. Dem Browser ist das egal, aber du erkennst so auf einen Blick, was in welchem Tag steckt.

Speichere die Datei mit Strg+S, auf dem Mac mit Cmd+S. Schau in den Browser: Die Willkommensseite ist verschwunden, und oben links steht groß und fett „Meine Aufgaben“. Neu laden musst du nicht, das erledigt der Entwicklungsserver.

Das Aussehen ist noch sehr schlicht. Darum kümmerst du dich im Durchgang zu CSS.

## Ein Absatz

Normalen Text schreibst du in einen Absatz. Das Tag dafür heißt `<p>`, vom englischen „paragraph“. Es funktioniert genau wie `<h1>`: öffnendes Tag, Text, schließendes Tag.

Der Browser zeigt einen Absatz in normaler Schriftgröße an und lässt davor und danach etwas Abstand.

## Deine Aufgabe

Ergänze unter der Überschrift einen Absatz mit einem eigenen Satz, zum Beispiel darüber, wofür du die Aufgabenliste benutzen möchtest.

Der Absatz gehört in eine eigene Zeile unter die Überschrift, aber noch vor `</template>`.

Wenn es geklappt hat, steht dein Satz im Browser in normaler Schrift unter der Überschrift.

### Wenn es nicht klappt

- **Im Browser ändert sich nichts:** Du hast die Datei noch nicht gespeichert. Ein Punkt neben dem Dateinamen im Reiter von VS Code zeigt ungespeicherte Änderungen an.
- **Der Browser zeigt eine Fehlermeldung statt deiner Seite:** Meist fehlt ein schließendes Tag oder der Schrägstrich darin. Zu jedem `<p>` gehört ein `</p>`. Korrigiere die Stelle und speichere, dann verschwindet die Meldung.
- **Dein Satz erscheint trotz Speichern nicht:** Er steht vermutlich außerhalb des Templates, also nach `</template>`. Alles Sichtbare muss zwischen `<template>` und `</template>` stehen.
- **Die Seite ist nicht erreichbar:** Der Entwicklungsserver läuft nicht. Starte ihn im Terminal mit `npm run dev`.

<!-- loesung -->

Dein Satz darf natürlich anders lauten.

```vue [app/app.vue]
<template>
  <h1>Meine Aufgaben</h1>
  <p>Hier sammle ich alles, was ich diese Woche erledigen möchte.</p>
</template>
```
