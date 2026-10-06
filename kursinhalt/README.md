# Kursinhalte

Hier liegen die Texte der Kurse als Markdown-Dateien. Aus ihnen entsteht das SQL, das die Kurse und Lektionen in die Datenbank schreibt.

## Aufbau

```
kursinhalt/
  erste-schritte/
    kurs.json
    01-willkommen.md
    02-....md
  todo-app/
    kurs.json
    01-was-wir-bauen.md
    ...
```

Jeder Kurs hat einen eigenen Ordner mit einer `kurs.json`. Ordner ohne `kurs.json` werden ignoriert.

## kurs.json

```json
{
  "slug": "todo-app",
  "title": "Todo-App",
  "summary": "Bau Schritt für Schritt deine erste eigene Web-App.",
  "position": 2,
  "recommended": "erste-schritte"
}
```

- `slug` ist der Adressteil des Kurses, `position` seine Reihenfolge in der Übersicht (jeweils eindeutig).
- `recommended` ist optional und nennt den Adressteil des Kurses, den man vorher machen sollte.

## Lektionsdateien

Der Dateiname lautet `NN-adressteil.md`. `NN` ist die Position in zwei Ziffern, der Rest der Adressteil der Lektion (nur Kleinbuchstaben, Ziffern und Bindestriche).

````markdown
---
title: Die erste Seite
summary: Du schreibst dein erstes HTML und siehst es sofort im Browser.
section: html
---

Text der Lektion ...

## Deine Aufgabe

...

<!-- loesung -->

```vue [app/app.vue]
<template>
  ...
</template>
```
````

- Der Kopf zwischen den `---` braucht `title`, `summary` und `section`.
- `section` ist einer von `start`, `html`, `css`, `js`, `abschluss`.
- Alles nach der Zeile `<!-- loesung -->` ist die Musterlösung. Ohne diese Zeile hat die Lektion keine.
- Jede Datei der Musterlösung steht in einem Codeblock mit Pfad in eckigen Klammern, zum Beispiel ```` ```vue [app/app.vue] ````. Aus diesen Blöcken baut `content:verify` die Zwischenstände.

## Regeln für Text außerhalb von Code

Der Renderer der Kursseite würde bestimmte Zeichen als Befehl lesen. Deshalb gilt außerhalb von Codeblöcken und Inline-Code:

- Kein `{{` im Text. Schreib `{{ name }}` immer in Backticks.
- Kein Wort, das mit `:` oder `@` beginnt (zum Beispiel `:class` oder `@click`). Auch das gehört in Backticks.
- Die Zeichenfolge `$lesson$` darf nirgends vorkommen, weil das SQL den Text damit einfasst.

Das Erzeugungsskript bricht bei einem Verstoß mit Dateiname und Zeile ab. Die Zeilen werden dabei ab 0 gezählt, die erste Zeile der Datei ist also Zeile 0.

## Befehle

```bash
yarn content:seed
```

Liest alle Kurse und schreibt `supabase/seeds/courses.sql`. Bei einem Fehler wird keine Datei geschrieben.

```bash
yarn content:verify <kurs-slug> [--from <NN>] [--to <NN>]
```

Baut jeden Zwischenstand der Musterlösungen eines Kurses in einem Prüfprojekt unter dem Temp-Ordner des Systems (`kurs-check-<kurs-slug>`) und ruft am Ende die gebaute App ab. Das erste Mal dauert einige Minuten, weil das Projekt angelegt und installiert wird. Der Server läuft auf einem freien Port, nie auf 3000.

## Wichtig

`courses.sql` wird nur einmal eingespielt. Danach ist die Datenbank maßgeblich: Das Skript überschreibt Änderungen, die später im Dashboard gemacht wurden. Spätere Änderungen macht man in der Datenbank, nicht durch erneutes Einspielen.
