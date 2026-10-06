---
title: Projekt anlegen
summary: Du legst dein Nuxt-Projekt an, startest es und siehst es zum ersten Mal im Browser.
section: start
---

Ein **Projekt** ist ein Ordner, in dem alle Dateien deiner App liegen. Du musst ihn nicht von Hand füllen: **Nuxt**, das Werkzeug, mit dem du die App baust, bringt einen Helfer mit, der ein startfertiges Projekt anlegt.

## Das Projekt anlegen

Öffne ein Terminal und wechsle in den Ordner `projekte`, den du im Kurs „Erste Schritte“ angelegt hast:

Gibt es den Ordner noch nicht, lege ihn zuerst mit `mkdir projekte` an.

```bash
cd projekte
```

Starte jetzt den Helfer. Das letzte Wort ist der Name deines Projektordners:

```bash
npm create nuxt@latest todo-app
```

Der Helfer stellt dir nacheinander ein paar Fragen auf Englisch. Eine Auswahl triffst du mit den Pfeiltasten und bestätigst sie mit der Eingabetaste. Der Wortlaut kann abweichen, halte dich dann an den Sinn.

1. Möglicherweise fragt zuerst npm, ob es den Helfer `create-nuxt` herunterladen darf. Bestätige mit der Eingabetaste.
2. **Welche Vorlage?** Wähle `minimal`, die kleinste Vorlage. Sie ist als empfohlen markiert.
3. **Welcher Paketmanager?** Wähle `npm`. Ein **Paketmanager** ist ein Programm, das Pakete herunterlädt. Ein **Paket** ist ein fertiger Baustein aus Code, den andere geschrieben haben und den npm für dich herunterlädt. npm hast du schon.
4. Danach lädt der Helfer Nuxt herunter. Das kann einige Minuten dauern.
5. **Git-Repository anlegen?** Wähle „No“. **Git** ist ein Werkzeug, das Änderungen an Dateien festhält. In diesem Kurs brauchst du es nicht.
6. **Module ansehen und installieren?** Wähle „No“.

Am Ende zeigt der Helfer die nächsten Schritte an, darunter `cd todo-app` und `npm run dev`. Dann hat alles geklappt.

## Die App starten

Wechsle in den neuen Ordner:

```bash
cd todo-app
```

Starte den **Entwicklungsserver**. Das ist ein Programm, das deine App auf deinem Rechner bereitstellt und sie bei jeder Änderung sofort neu lädt:

```bash
npm run dev
```

Beim allerersten Start fragt Nuxt eventuell, ob es anonyme Nutzungsdaten senden darf. Beide Antworten sind in Ordnung.

Nach kurzer Zeit zeigt das Terminal eine Adresse an, normalerweise `http://localhost:3000`. Das Wort `localhost` steht für deinen eigenen Rechner. Öffne die Adresse im Browser.

Zeigt das Terminal am Ende eine andere Zahl, zum Beispiel `3001`, dann nimm genau diese Adresse.

Du solltest eine Willkommensseite von Nuxt sehen. Am unteren Rand erscheint vielleicht ein kleines Nuxt-Symbol. Es gehört zu einem Entwicklerwerkzeug, das du in diesem Kurs nicht brauchst.

Der Server läuft, bis du ihn mit Strg+C stoppst, auf dem Mac mit Control+C.

## Den Ordner in VS Code öffnen

Starte VS Code und wähle im Menü „File“ den Punkt „Open Folder“. In der deutschen Oberfläche heißen sie „Datei“ und „Ordner öffnen“. Wähle den Ordner `todo-app` aus. Fragt VS Code, ob du den Autoren der Dateien vertraust, bestätige das.

Links siehst du jetzt alle Dateien des Projekts. Die wichtigsten sind:

- `app/app.vue` ist die Seite, die du im Browser siehst. In dieser Datei arbeitest du fast den ganzen Kurs über.
- `nuxt.config.ts` enthält die Einstellungen für Nuxt.
- `package.json` listet auf, welche Bausteine dein Projekt braucht und welche Befehle es kennt, zum Beispiel `dev`.
- `node_modules` enthält die heruntergeladenen Bausteine. Der Ordner ist riesig, und du fasst ihn nie an.

Klicke auf `app/app.vue`. Die Datei ist kurz:

```vue [app/app.vue]
<template>
  <div>
    <NuxtRouteAnnouncer />
    <NuxtWelcome />
  </div>
</template>
```

Die Zeile mit `NuxtWelcome` erzeugt die Willkommensseite. In der nächsten Lektion ersetzt du sie durch deine eigene erste Zeile.

## Später weitermachen

Vor einer Pause stoppst du den Server mit Strg+C. Beim nächsten Mal öffnest du in VS Code das Menü „Terminal“ und wählst „New Terminal“, auf Deutsch „Neues Terminal“. Dieses Terminal steht sofort im Projektordner, und du startest dort wieder `npm run dev`.

## Wenn es nicht klappt

- **Der Befehl `npm` wird nicht gefunden:** Node.js fehlt. Schau in den Kurs „Erste Schritte“.
- **`npm run dev` meldet, dass ein Skript oder eine `package.json` fehlt:** Du bist im falschen Ordner. Wechsle mit `cd todo-app` in dein Projekt.
- **Der Browser zeigt, dass die Seite nicht erreichbar ist:** Der Server läuft nicht, oder die Adresse stimmt nicht mit der im Terminal überein.
