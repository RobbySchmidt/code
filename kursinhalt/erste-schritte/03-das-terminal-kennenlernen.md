---
title: Das Terminal kennenlernen
summary: Du öffnest das Terminal, prüfst deine Installation und lernst die wichtigsten Befehle.
section: start
---

Viele Werkzeuge der Programmierung steuerst du nicht mit der Maus, sondern mit Text. Dafür gibt es das Terminal.

Ein **Terminal** ist ein Fenster, in das du Befehle tippst. Der Rechner führt sie aus und antwortet mit Text. Ein **Befehl** ist eine kurze Anweisung, die du mit der Eingabetaste abschickst.

## Das Terminal öffnen

Unter Windows:

1. Öffne das Startmenü.
2. Tippe `PowerShell` ein und öffne das gefundene Programm.

Auf dem Mac:

1. Drücke Cmd+Leertaste, damit die Suche aufgeht.
2. Tippe `Terminal` ein und drücke die Eingabetaste.

Du siehst ein Fenster mit einer Zeile, die auf deine Eingabe wartet. Meist steht dort der Name oder Pfad des aktuellen Ordners. Das ist normal.

Später kannst du auch das Terminal in VS Code benutzen. Du findest es im Menü „Terminal“ von VS Code. Es verhält sich genauso.

## Deine Installation prüfen

Tippe diesen Befehl ein und drücke die Eingabetaste:

```bash
node --version
```

Du solltest eine Zeile sehen, die mit `v` beginnt und drei Zahlen enthält, zum Beispiel `v24.x.x`. Die Zahlen bei dir können anders sein.

Prüfe jetzt npm:

```bash
npm --version
```

Auch hier erscheint eine Zeile mit drei Zahlen, zum Beispiel `12.x.x`.

Statt der Zahlen kann eine Fehlermeldung erscheinen, zum Beispiel dass der Befehl nicht gefunden wurde. Dann schließe das Terminal, öffne es neu und versuche es noch einmal. Hilft das nicht, installiere Node.js aus der letzten Lektion erneut.

## Sich im Ordnersystem bewegen

Das Terminal ist immer in einem **Ordner**. Mit diesen Befehlen bewegst du dich darin:

- `ls` zeigt, was im aktuellen Ordner liegt.
- `mkdir name` legt einen neuen Ordner mit diesem Namen an.
- `cd name` wechselt in den Ordner mit diesem Namen.
- `cd ..` geht einen Ordner zurück.

Lege jetzt einen Ordner für deine Arbeit an:

```bash
mkdir projekte
```

Bei der Windows PowerShell zeigt das Terminal danach eine kleine Tabelle mit dem neuen Ordner. Auf dem Mac erscheint nichts, das ist dort normal.

Wechsle in den Ordner:

```bash
cd projekte
```

Es erscheint keine Meldung. Die Zeile vor deiner Eingabe zeigt jetzt den Namen `projekte`.

Mit `ls` siehst du, was im Ordner liegt. Er ist neu, deshalb erscheint nichts:

```bash
ls
```

Zum Schluss gehst du wieder zurück:

```bash
cd ..
```

Wenn du `mkdir projekte` ein zweites Mal ausführst, meldet das Terminal einen Fehler, weil der Ordner schon existiert. Das schadet nicht.

## Einen laufenden Befehl beenden

Manche Befehle laufen weiter, bis du sie stoppst. Später gehört dazu der Server deiner App. Drücke dann Strg+C, auf dem Mac Control+C. Das Terminal ist danach wieder bereit für neue Befehle.

## Das solltest du jetzt haben

- Du kannst das Terminal öffnen.
- `node --version` und `npm --version` zeigen je eine Versionsnummer.
- Du hast einen Ordner `projekte` angelegt und kannst hinein- und wieder herauswechseln.
- Du weißt, dass du mit Strg+C einen laufenden Befehl beendest.

Damit bist du bereit für den Kurs „Todo-App“. Darin baust du mit Nuxt deine erste eigene Aufgabenliste.
