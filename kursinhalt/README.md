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
  "recommended": "erste-schritte",
  "packages": ["tailwindcss", "@tailwindcss/vite", "@lucide/vue"]
}
```

- `slug` ist der Adressteil des Kurses, `position` seine Reihenfolge in der Übersicht (jeweils eindeutig).
- `recommended` ist optional und nennt den Adressteil des Kurses, den man vorher machen sollte. Dieser Kurs muss nicht mit erzeugt werden: Es genügt, dass er in `kursinhalt/` liegt, das SQL verweist nur über den Adressteil auf ihn.
- `packages` ist optional, eine Liste von npm-Paketen, die `content:verify` in das Prüfprojekt installiert. Das Erzeugen des SQL ignoriert das Feld.

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

- Der Kopf zwischen den `---` braucht `title`, `summary` und `section`. Die Werte werden wörtlich übernommen. Schreib sie deshalb ohne YAML-Anführungszeichen, sonst erscheinen die Anführungszeichen später im Titel.
- `section` ist einer von `start`, `html`, `css`, `js`, `abschluss`.
- Alles nach der Zeile `<!-- loesung -->` ist die Musterlösung. Ohne diese Zeile hat die Lektion keine. Die Zeile darf nicht innerhalb eines Codeblocks stehen: Sie wird zeilenweise gesucht und würde dort trotzdem trennen.
- Jede Datei der Musterlösung steht in einem Codeblock mit Pfad in eckigen Klammern, zum Beispiel ```` ```vue [app/app.vue] ````. Aus diesen Blöcken baut `content:verify` die Zwischenstände.

## Regeln für Text außerhalb von Code

Der Renderer der Kursseite würde bestimmte Zeichen als Befehl lesen. Deshalb gilt außerhalb von Codeblöcken und Inline-Code:

- Kein `{{` im Text. Schreib `{{ name }}` immer in Backticks.
- Kein Wort, das mit `:` oder `@` beginnt (zum Beispiel `:class` oder `@click`). Auch das gehört in Backticks.
- Kein `:` und kein `@` direkt hinter `*`, `_`, `"`, `„` oder `'`. Fettschrift um einen Befehl wie `**:class**` geht also nicht. Setz den Befehl in Backticks, mit oder ohne Fettschrift darum.
- Kein `<` direkt vor einem Buchstaben, `/` oder `!`. Ein nacktes Tag im Fließtext würde als HTML gerendert. Schreib es in Backticks, zum Beispiel `<div>`. Ein `<` vor einem Leerzeichen ("kleiner als 5 < 10") ist erlaubt, ebenso die Markerzeile `<!-- loesung -->`.
- Keine Zeile, die mit `::` und einem Buchstaben beginnt (zum Beispiel `::card`). Das wäre ein Block-Baustein des Renderers. Setz die Zeile in einen Codeblock.
- Die Zeichenfolge `$lesson` darf nirgends vorkommen, auch nicht in Codeblöcken oder Inline-Code, weil das SQL den Text mit `$lesson$` einfasst.
- Codeblöcke dürfen mit drei oder mehr Backticks oder mit `~~~` eingezäunt sein (bis zu drei Leerzeichen eingerückt). Ein Block wird nur von einem Zaun gleicher Art und mindestens gleicher Länge geschlossen.

Das Erzeugungsskript bricht bei einem Verstoß mit Dateiname, Zeile und Abhilfe ab. Die Zeilen werden ab 1 gezählt, die erste Zeile der Datei ist also Zeile 1.

## Hervorgehobene Sprachen

Die Kursseite färbt Codeblöcke dieser Sprachen ein: `vue`, `html`, `css`, `js`, `ts`, `json`, `bash`, `powershell`. Andere Sprachen erscheinen ohne Farbe. In der Leiste über dem Block steht der Dateiname. Fehlt er, steht dort bei Shell-Blöcken (`bash`, `sh`, `shell`, `powershell`) „Terminal“, sonst die Sprache.

## Befehle

```bash
yarn content:seed [<kurs-slug> ...] [--prune]
```

- Ohne Kursnamen werden alle Kurse gelesen und `supabase/seeds/courses.sql` geschrieben.
- Mit Kursnamen (`yarn content:seed galerie`) entsteht nur das SQL für diese Kurse, in `supabase/seeds/courses-<slug>[-<slug>...].sql`. Der Pfad wird ausgegeben. Ein unbekannter Name ist ein Fehler, dann wird nichts geschrieben.
- Das SQL steht zwischen `begin;` und `commit;`. Schlägt es beim Einspielen fehl, bleibt die Datenbank unverändert.
- Ohne `--prune` löscht das SQL nichts. Lektionen, die im Repository fehlen, bleiben in der Datenbank. Pro Kurs steht dazu ein Hinweis als Kommentar in der Datei. Mit `yarn content:seed --prune` werden sie samt dem Fortschritt der Lernenden gelöscht.
- Bei einem Fehler im Text wird keine Datei geschrieben.

```bash
yarn content:verify <kurs-slug> [--from <NN>] [--to <NN>]
```

Baut jeden Zwischenstand der Musterlösungen eines Kurses in einem Prüfprojekt. Nach jedem Build startet das Skript die gebaute App auf einem freien Port (nie 3000), ruft `/` ab und verlangt HTTP 200. Danach beendet es den Server wieder.

Das beweist, dass jeder Zustand baut und ausgeliefert wird. Es beweist nicht, dass die App richtig aussieht oder funktioniert: Das Skript klickt nichts an und prüft keine Inhalte.

Das Prüfprojekt liegt im Temp-Ordner des Systems unter `kurs-check-<kurs-slug>`. Das erste Mal dauert es einige Minuten, weil das Projekt angelegt und installiert wird. Löschst du diesen Ordner, beginnt das Skript beim nächsten Mal von vorn. Die npm-Pakete, die zusätzlich in das Projekt kommen, stehen im Feld `packages` der `kurs.json`. Fehlt ein Paket aus dieser Liste im Prüfprojekt, wird es nachinstalliert.

## Einen Kurs in die laufende Datenbank bringen

1. Erzeuge nur den neuen Kurs mit seinem Adressteil: `yarn content:seed neuer-kurs`.
2. Lies den Kopf der erzeugten Datei `supabase/seeds/courses-neuer-kurs.sql`. Er sagt, was das Einspielen überschreibt.
3. Spiel die Datei ein, mit den Zugangsdaten aus `.env` in der Umgebung: `yarn -s supabase db query --linked -f supabase/seeds/courses-neuer-kurs.sql`.
4. Spiel nie wieder einen vollständigen Seed über Texte ein, die im Dashboard bearbeitet wurden, außer du willst genau das: Er überschreibt sie mit der Fassung aus dem Repository.
