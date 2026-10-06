---
title: Das Terminal kennenlernen
summary: Du öffnest das Terminal, prüfst deine Installation und lernst die wichtigsten Befehle.
section: start
---

Viele Werkzeuge der Programmierung steuerst du mit Text statt mit der Maus.

Ein **Terminal** ist ein Fenster, in das du Befehle tippst. Der Rechner führt sie aus und antwortet mit Text. Ein **Befehl** ist eine kurze Anweisung, die du mit der Eingabetaste abschickst.

## Das Terminal öffnen

Unter Windows:

1. Öffne das Startmenü.
2. Tippe `PowerShell` ein und öffne das gefundene Programm.

Auf dem Mac:

1. Drücke Cmd+Leertaste, damit die Suche aufgeht.
2. Tippe `Terminal` ein und drücke die Eingabetaste.

Du siehst eine Zeile, die auf deine Eingabe wartet. Meist steht dort der **Pfad** des aktuellen Ordners, also seine Adresse im Ordnersystem. Das ist normal.

Auch VS Code hat ein Terminal, du findest es im Menü „Terminal“. Es verhält sich genauso.

## Deine Installation prüfen

Tippe diesen Befehl ein und drücke die Eingabetaste:

```bash
node --version
```

Du solltest eine Zeile sehen, die mit `v` beginnt und drei Zahlen enthält, zum Beispiel `v24.x.x`.

Prüfe jetzt npm:

```bash
npm --version
```

Auch hier erscheint eine Zeile mit drei Zahlen, zum Beispiel `12.x.x`.

Wenn stattdessen eine Fehlermeldung erscheint, dass der Befehl nicht gefunden wurde, schließe das Terminal und öffne es neu. Das gilt auch für das Terminal in VS Code. Hilft das nicht, installiere Node.js aus der letzten Lektion erneut.

Nur unter Windows kann noch etwas anderes passieren: `node --version` funktioniert, aber `npm --version` zeigt einen roten Fehler, in dem es um Skripts oder scripts geht, die auf diesem System nicht ausgeführt werden dürfen. Dann blockiert PowerShell Skriptdateien von Haus aus. Wenn du diesen Fehler siehst, führe einmal diesen Befehl aus und versuche `npm --version` danach erneut:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Der Befehl erlaubt deinem Benutzerkonto, Skripts auszuführen, die auf deinem Computer installiert sind. Für andere Benutzer ändert er nichts. PowerShell fragt eventuell nach einer Bestätigung, die du mit J oder Y beantwortest.

## Sich im Ordnersystem bewegen

Das Terminal ist immer in einem **Ordner**. Mit diesen Befehlen bewegst du dich darin:

- `ls` zeigt, was im aktuellen Ordner liegt.
- `mkdir name` legt einen neuen Ordner mit diesem Namen an.
- `cd name` wechselt in den Ordner mit diesem Namen.
- `cd ..` geht einen Ordner zurück.

Schau dir zuerst an, wo du gerade bist:

```bash
ls
```

Du siehst die Namen der Ordner und Dateien, die in diesem Ordner liegen.

Lege jetzt einen Ordner für deine Arbeit an. Er entsteht in dem Ordner, in dem das Terminal gerade steht:

```bash
mkdir projekte
```

In der Windows-PowerShell zeigt das Terminal danach eine kleine Tabelle mit dem neuen Ordner. Auf dem Mac erscheint nichts, das ist dort normal. Mit `ls` siehst du `projekte` jetzt in der Liste.

Wechsle in den Ordner:

```bash
cd projekte
```

Es erscheint keine Meldung. Die Zeile vor deiner Eingabe zeigt jetzt den Namen `projekte`.

Mit `ls` siehst du noch einmal, was im Ordner liegt. Er ist neu, deshalb erscheint nichts:

```bash
ls
```

Zum Schluss gehst du wieder zurück:

```bash
cd ..
```

Wieder erscheint keine Meldung, und die Zeile zeigt den vorherigen Ordner.

## Einen laufenden Befehl beenden

Manche Befehle laufen weiter, bis du sie stoppst. Dazu gehört später der **Server** deiner App, ein Programm, das deine App im Browser anzeigbar macht und so lange läuft, bis du es stoppst. Drücke dann Strg+C, auf dem Mac Control+C. Das Terminal ist danach wieder bereit für neue Befehle.

## Das solltest du jetzt haben

- Du kannst das Terminal öffnen.
- `node --version` und `npm --version` zeigen je eine Versionsnummer.
- Du hast einen Ordner `projekte` angelegt und kannst hinein- und wieder herauswechseln.
- Du weißt, dass du mit Strg+C einen laufenden Befehl beendest.

Damit bist du bereit für den Kurs „Todo-App“. Darin baust du mit Nuxt, dem Werkzeug aus der vorigen Lektion, deine erste eigene Aufgabenliste.
