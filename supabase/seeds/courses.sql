-- Erzeugt von `yarn content:seed`. Nicht von Hand ändern.
-- Nur einmal einspielen: Das Skript überschreibt Änderungen, die später im Dashboard gemacht wurden.

update public.courses set position = position + 1000 where slug in ('erste-schritte', 'todo-app');

insert into public.courses (slug, title, summary, position, published) values
  ('erste-schritte', 'Erste Schritte', 'Hier richtest du deinen Rechner ein und lernst, wie die Kurse funktionieren.', 1, true),
  ('todo-app', 'Todo-App', 'Bau Schritt für Schritt deine erste eigene Web-App: eine Aufgabenliste mit Nuxt.', 2, true)
on conflict (slug) do update set
  title = excluded.title,
  summary = excluded.summary,
  position = excluded.position,
  published = excluded.published;

update public.courses
set recommended_course_id = null
where slug = 'erste-schritte';

update public.courses
set recommended_course_id = (select id from public.courses where slug = 'erste-schritte')
where slug = 'todo-app';

delete from public.lessons
where course_id = (select id from public.courses where slug = 'erste-schritte')
  and slug not in ('willkommen', 'werkzeuge-einrichten', 'das-terminal-kennenlernen');

delete from public.lessons
where course_id = (select id from public.courses where slug = 'todo-app')
  and slug not in ('was-wir-bauen', 'projekt-anlegen', 'die-erste-seite', 'das-geruest-der-todo-app', 'tailwind-einrichten', 'die-app-stylen', 'icons-mit-lucide', 'feinschliff', 'daten-anzeigen', 'aufgaben-hinzufuegen', 'aufgaben-abhaken', 'aufgaben-loeschen', 'zaehler-und-leere-liste', 'in-komponenten-aufteilen', 'speichern-im-browser', 'geschafft');

update public.lessons set position = position + 1000
where course_id = (select id from public.courses where slug = 'erste-schritte');

insert into public.lessons (course_id, slug, title, summary, position, section, content, solution, published) values
  (
    (select id from public.courses where slug = 'erste-schritte'),
    'willkommen', 'Willkommen', 'Du erfährst, für wen die Kurse sind, wie eine Lektion aufgebaut ist und was du brauchst.', 1, 'start',
    $lesson$Schön, dass du da bist. Diese Kurse sind für Menschen, die noch nie programmiert haben. Du brauchst kein Vorwissen, nur Neugier und etwas Geduld.

Du lernst hier nicht nur zu lesen, sondern vor allem zu machen. Am Ende steht eine eigene kleine **Web-App**, also ein Programm, das im Browser läuft wie eine Webseite und das du selbst gebaut hast.

## Du arbeitest auf deinem eigenen Rechner

Alles, was du lernst, probierst du auf deinem Computer aus. Dafür installierst du in der nächsten Lektion zwei kostenlose Programme.

Du kannst dabei nichts kaputt machen. Die Dateien, die du anlegst, liegen in einem eigenen Ordner. Wenn etwas schiefgeht, löschst du den Ordner und fängst von vorn an.

## So ist eine Lektion aufgebaut

Eine Lektion mit Code hat immer drei Teile:

1. **Erklärung:** Ein neues Thema, an einem kleinen Beispiel gezeigt.
2. **Deine Aufgabe:** Du setzt das Gelernte selbst um. Das ist der wichtigste Teil, denn Programmieren lernt man nur durch Ausprobieren.
3. **Musterlösung:** Unter der Aufgabe findest du eine aufklappbare Lösung. Schau erst hinein, wenn du es selbst versucht hast oder wirklich nicht weiterkommst.

Die drei Lektionen dieses Kurses sind eine Ausnahme: Hier gibt es keine Aufgabe, denn du richtest erst einmal alles ein.

## Lektionen abschließen und Fortschritt speichern

Am Ende jeder Lektion steht der Knopf „Lektion abschließen“. Mit ihm merkst du dir, was du schon geschafft hast.

Den Knopf siehst du nur, wenn du angemeldet bist. Ein **Konto** ist ein persönlicher Zugang zur Seite. Es ist kostenlos, du brauchst nur eine E-Mail-Adresse und ein Passwort. Mit einem Konto speichert die Seite deinen Fortschritt, und „Kurs weitermachen“ bringt dich später genau dorthin zurück, wo du aufgehört hast.

Ohne Konto kannst du alle Lektionen trotzdem lesen. Nur der Fortschritt wird dann nicht gespeichert. Wenn du nicht angemeldet bist, zeigt dir die Seite am Ende einer Lektion einen Hinweis zum Anmelden.

Alle Kurse findest du in der Übersicht unter `/kurse`. Dort wählst du einen Kurs aus und siehst seine Lektionen, in Blöcken geordnet.

## Was du brauchst

- einen Rechner mit Windows oder macOS
- eine Internetverbindung
- etwa eine Stunde Zeit für diesen Kurs

Mehr nicht. Alles Weitere richtest du in der nächsten Lektion ein.

Jetzt weißt du, wie die Kurse funktionieren. Weiter geht es mit der nächsten Lektion.$lesson$,
    null,
    true
  ),
  (
    (select id from public.courses where slug = 'erste-schritte'),
    'werkzeuge-einrichten', 'Werkzeuge einrichten', 'Du installierst Node.js und den Code-Editor VS Code.', 2, 'start',
    $lesson$Zum Programmieren brauchst du zwei Werkzeuge. Du installierst beide auf deinem Rechner, beide sind kostenlos.

## Node.js installieren

**Node.js** ist ein Programm, das Code in der Programmiersprache **JavaScript** direkt auf deinem Rechner ausführen kann. Die Werkzeuge, mit denen du später deine App baust, laufen darauf. Mit Node.js kommt außerdem **npm** auf deinen Rechner, ein Helfer, der Programmbausteine für dich herunterlädt.

So gehst du vor:

1. Öffne im Browser die Seite `https://nodejs.org`.
2. Lade die Version mit der Bezeichnung **LTS** herunter. LTS steht für „Long Term Support“, also eine Version, die lange gepflegt wird und besonders stabil ist.
3. Starte die heruntergeladene Datei und folge dem Installationsprogramm.
4. Lass dabei alle Einstellungen so, wie sie vorgeschlagen werden, und klicke dich bis zum Ende durch.

Wenn das Installationsprogramm fertig ist, ist Node.js installiert. Auf dem Bildschirm siehst du dafür meistens nichts Besonderes. Geprüft wird es in der nächsten Lektion.

## Einen Code-Editor installieren

Ein **Code-Editor** ist ein Programm zum Schreiben von Code. Er funktioniert wie ein Textverarbeitungsprogramm, kann aber Code einfärben, übersichtlich anzeigen und dir beim Tippen helfen.

Wir benutzen dafür **Visual Studio Code**, kurz VS Code:

1. Öffne die Seite `https://code.visualstudio.com`.
2. Lade die Version für dein Betriebssystem herunter, also Windows oder macOS.
3. Unter Windows startest du die heruntergeladene Datei und folgst dem Installationsprogramm. Auch hier sind die vorgeschlagenen Einstellungen in Ordnung.
4. Auf dem Mac ist der Download meist ein Archiv, das die App enthält. Öffne es und ziehe die App VS Code in den Ordner „Programme“.
5. Starte VS Code. Unter Windows findest du es im Startmenü, auf dem Mac im Ordner „Programme“ oder im Launchpad.

Du solltest jetzt ein Fenster mit einer Startseite sehen. Es ist normal, dass es noch leer wirkt.

## Die Erweiterung „Vue (Official)“ installieren

Eine **Erweiterung** ist ein Zusatz, der den Editor um eine Fähigkeit ergänzt. **Vue** ist der Baukasten für Webseiten, auf dem Nuxt aufbaut. Die Erweiterung „Vue (Official)“ bringt VS Code bei, die Dateien dieses Baukastens zu verstehen und farbig darzustellen.

1. Öffne in VS Code den Bereich für Erweiterungen. Du findest ihn in der Leiste am Rand des Fensters, das Symbol zeigt mehrere Quadrate.
2. Tippe in das Suchfeld `Vue - Official` ein.
3. Wähle den Eintrag „Vue (Official)“ aus der Ergebnisliste aus und klicke auf den Knopf zum Installieren.

Danach erscheint die Erweiterung in deiner Liste der installierten Erweiterungen.

## Das solltest du jetzt haben

- Node.js (LTS-Version) ist installiert.
- VS Code ist installiert und lässt sich starten.
- Die Erweiterung „Vue (Official)“ ist installiert.

Ob Node.js wirklich funktioniert, prüfst du in der nächsten Lektion im Terminal.$lesson$,
    null,
    true
  ),
  (
    (select id from public.courses where slug = 'erste-schritte'),
    'das-terminal-kennenlernen', 'Das Terminal kennenlernen', 'Du öffnest das Terminal, prüfst deine Installation und lernst die wichtigsten Befehle.', 3, 'start',
    $lesson$Viele Werkzeuge der Programmierung steuerst du mit Text statt mit der Maus.

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

Damit bist du bereit für den Kurs „Todo-App“. Darin baust du mit **Nuxt**, einem Werkzeug zum Bauen von Web-Apps, deine erste eigene Aufgabenliste.$lesson$,
    null,
    true
  )
on conflict (course_id, slug) do update set
  title = excluded.title,
  summary = excluded.summary,
  position = excluded.position,
  section = excluded.section,
  content = excluded.content,
  solution = excluded.solution,
  published = excluded.published;

update public.lessons set position = position + 1000
where course_id = (select id from public.courses where slug = 'todo-app');

insert into public.lessons (course_id, slug, title, summary, position, section, content, solution, published) values
  (
    (select id from public.courses where slug = 'todo-app'),
    'was-wir-bauen', 'Was wir bauen', 'Du lernst die fertige Aufgabenliste kennen und erfährst, in welchen Schritten sie entsteht.', 1, 'start',
    $lesson$In diesem Kurs baust du deine erste eigene Web-App: eine Aufgabenliste. Solche Apps heißen oft **Todo-App**, nach dem englischen „to do“, also „zu erledigen“.

Du baust sie auf deinem eigenen Rechner, Zeile für Zeile, und siehst nach jedem Schritt im Browser, was sich verändert hat.

## Das kann die fertige App

Am Ende des Kurses hast du eine kleine Seite mit einer weißen Karte in der Mitte. Darauf steht die Überschrift „Meine Aufgaben“ und darunter, wie viele Aufgaben noch offen sind.

Mit der App kannst du:

- eine neue Aufgabe in ein Eingabefeld tippen und zur Liste hinzufügen
- eine Aufgabe als erledigt abhaken, sie wird dann grau und durchgestrichen
- eine einzelne Aufgabe löschen
- alle Aufgaben auf einmal löschen
- den Browser schließen und später weitermachen, denn die App merkt sich deine Aufgaben

Das klingt nach wenig, aber in dieser kleinen App steckt fast alles, was auch große Web-Apps ausmacht: Inhalt, Aussehen und Verhalten.

## Drei Durchgänge

Genau in diesen drei Teilen entsteht die App. Du gehst dreimal durch dieselbe Seite und fügst jedes Mal eine Schicht hinzu.

1. **HTML** ist die Sprache, die den Inhalt einer Seite beschreibt: Hier steht eine Überschrift, dort ein Eingabefeld, darunter eine Liste. Nach diesem Durchgang ist alles da, sieht aber noch schlicht aus und tut nichts.
2. **CSS** ist die Sprache für das Aussehen: Farben, Abstände, Schriftgrößen. Nach diesem Durchgang sieht die App fertig aus, tut aber immer noch nichts.
3. **JavaScript** ist die Programmiersprache, die der Seite Verhalten gibt. Erst in diesem Durchgang kannst du wirklich Aufgaben hinzufügen, abhaken und löschen.

Diese Reihenfolge hat einen Vorteil: Du lernst immer nur eine Sache auf einmal. Lass dich also nicht davon irritieren, dass die Knöpfe der App lange Zeit nichts bewirken. Das ist so geplant.

## So arbeitest du

Jede Lektion zeigt dir zuerst etwas Neues an einem kleinen Beispiel. Danach kommt der Abschnitt „Deine Aufgabe“, in dem du den nächsten Teil der App selbst baust. Darunter findest du eine Musterlösung zum Aufklappen.

Versuch die Aufgabe immer erst selbst. Es ist völlig normal, dabei Fehler zu machen und zu suchen. Genau dabei lernst du am meisten. Die Musterlösung zeigt die betroffenen Dateien immer vollständig. Wenn du dich einmal verrannt hast, kannst du ihren Inhalt übernehmen und bist wieder auf dem richtigen Stand.

Plane für eine Lektion zehn bis zwanzig Minuten ein.

## Was du vorher brauchst

Für diesen Kurs müssen auf deinem Rechner Node.js und der Editor VS Code installiert sein, und du solltest wissen, wie du ein Terminal öffnest und mit `cd` in einen Ordner wechselst.

Das alles lernst du im Kurs „Erste Schritte“. Wenn du ihn noch nicht gemacht hast, fang dort an und komm danach hierher zurück.

Wenn alles eingerichtet ist, legst du in der nächsten Lektion dein Projekt an.$lesson$,
    null,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'projekt-anlegen', 'Projekt anlegen', 'Du legst dein Nuxt-Projekt an, startest es und siehst es zum ersten Mal im Browser.', 2, 'start',
    $lesson$Ein **Projekt** ist ein Ordner, in dem alle Dateien deiner App liegen. Du musst ihn nicht von Hand füllen: **Nuxt**, das Werkzeug, mit dem du die App baust, bringt einen Helfer mit, der ein startfertiges Projekt anlegt.

## Das Projekt anlegen

Öffne ein Terminal und wechsle in den Ordner `projekte`, den du im Kurs „Erste Schritte“ angelegt hast:

```bash
cd projekte
```

Starte jetzt den Helfer. Das letzte Wort ist der Name deines Projektordners:

```bash
npm create nuxt@latest todo-app
```

Der Helfer stellt dir nacheinander ein paar Fragen auf Englisch. Eine Auswahl triffst du mit den Pfeiltasten und bestätigst sie mit der Eingabetaste. Der Wortlaut kann bei dir etwas anders sein, weil der Helfer weiterentwickelt wird. Halte dich dann an ihren Sinn.

1. Möglicherweise fragt zuerst npm, ob es den Helfer `create-nuxt` herunterladen darf. Bestätige mit der Eingabetaste.
2. **Welche Vorlage?** Wähle `minimal`, die kleinste Vorlage. Sie ist als empfohlen markiert.
3. **Welcher Paketmanager?** Wähle `npm`. Ein **Paketmanager** ist ein Programm, das Bausteine herunterlädt, und npm hast du schon.
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

### Wenn es nicht klappt

- **Der Befehl `npm` wird nicht gefunden:** Node.js fehlt. Schau in den Kurs „Erste Schritte“.
- **`npm run dev` meldet, dass ein Skript oder eine `package.json` fehlt:** Du bist im falschen Ordner. Wechsle mit `cd todo-app` in dein Projekt.
- **Der Browser zeigt, dass die Seite nicht erreichbar ist:** Der Server läuft nicht, oder die Adresse stimmt nicht mit der im Terminal überein.$lesson$,
    null,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'die-erste-seite', 'Die erste Seite', 'Du schreibst dein erstes HTML und siehst es sofort im Browser.', 3, 'html',
    $lesson$Jetzt ersetzt du die Willkommensseite von Nuxt durch deine eigene Seite. Dafür muss der Entwicklungsserver laufen. Falls nicht, starte ihn im Terminal:

```bash
npm run dev
```

Öffne die App im Browser und stell Browser und VS Code am besten nebeneinander.

## Das Template

Öffne in VS Code die Datei `app/app.vue`. Alles, was auf der Seite erscheinen soll, steht zwischen `<template>` und `</template>`.

Eine **Vue-Datei**, erkennbar an der Endung `.vue`, enthält ein Stück deiner App. Das **Template** ist der Teil einer Vue-Datei, der beschreibt, was auf der Seite zu sehen ist. Geschrieben wird es in HTML, der Sprache für den Inhalt von Webseiten.

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
- **Die Fehlermeldung bleibt, obwohl alle Tags geschlossen sind:** Der Absatz steht vermutlich außerhalb des Templates, also nach `</template>`. Alles Sichtbare muss zwischen `<template>` und `</template>` stehen.
- **Die Seite ist nicht erreichbar:** Der Entwicklungsserver läuft nicht. Starte ihn mit dem Befehl vom Anfang der Lektion.$lesson$,
    $lesson$Dein Satz darf natürlich anders lauten.

```vue [app/app.vue]
<template>
  <h1>Meine Aufgaben</h1>
  <p>Hier sammle ich alles, was ich diese Woche erledigen möchte.</p>
</template>
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'das-geruest-der-todo-app', 'Das Gerüst der Todo-App', 'Du baust mit HTML alle Teile der App auf: Formular, Liste und Buttons.', 4, 'html',
    $lesson$In dieser Lektion entsteht das Gerüst der ganzen App. Am Ende ist alles da, was du später brauchst: ein Eingabefeld, eine Liste mit Aufgaben und die Buttons. Hübsch ist es noch nicht, und klicken bringt noch nichts.

## Tags in Tags

Tags dürfen ineinander stecken. So entsteht eine Ordnung: Ein äußeres Tag fasst mehrere innere zusammen.

Das Tag `<main>` umschließt den Hauptinhalt einer Seite. Bei uns ist das die ganze App. Alles Weitere schreibst du dort hinein und rückst es um zwei weitere Leerzeichen ein.

## Das Formular

Ein **Formular** ist ein Bereich, in dem jemand etwas eingibt und abschickt. Das Tag dafür ist `<form>`. In unserem Formular stecken zwei Dinge:

- `<input>` ist ein Eingabefeld. Es hat keinen Inhalt und deshalb auch kein schließendes Tag.
- `<button>` ist ein **Button**, also ein Knopf zum Anklicken. Der Text zwischen den Tags steht auf dem Knopf.

Ändere `app/app.vue` so:

```vue [app/app.vue]
<template>
  <main>
    <h1>Meine Aufgaben</h1>
    <p>2 offen</p>

    <form>
      <input type="text" placeholder="Neue Aufgabe">
      <button type="submit">Hinzufügen</button>
    </form>
  </main>
</template>
```

Deinen Satz aus der letzten Lektion ersetzt die Zeile „2 offen“. Später zählt die App die offenen Aufgaben selbst. Bis dahin steht die Zahl einfach fest im Text.

Speichere und schau in den Browser. Unter der Überschrift siehst du ein Eingabefeld mit dem grauen Text „Neue Aufgabe“ und daneben den Button „Hinzufügen“.

## Attribute

Im öffnenden Tag von `<input>` und `<button>` steht mehr als nur der Name. Das sind Attribute. Ein **Attribut** ist eine Zusatzangabe zu einem Tag. Es besteht aus einem Namen, einem Gleichheitszeichen und einem Wert in Anführungszeichen.

- `type="text"` legt fest, dass in das Feld normaler Text getippt wird.
- `placeholder="Neue Aufgabe"` ist der graue Hinweistext. Er verschwindet, sobald du etwas eintippst.
- `type="submit"` macht den Button zum Abschicken-Knopf des Formulars.

Probier es aus: Tippe etwas ein und klicke auf „Hinzufügen“. Die Seite lädt kurz neu, und dein Text ist weg. Das ist im Moment richtig so. Was beim Abschicken passieren soll, programmierst du im Durchgang zu JavaScript.

## Listen und weitere Buttons

Für deine Aufgabe brauchst du noch zwei Tags, die immer zusammen auftreten:

- `<ul>` umschließt eine ganze Liste.
- `<li>` umschließt einen einzelnen Eintrag und steht innerhalb von `<ul>`.

In einem `<li>` kann Text stehen, aber auch weitere Tags, zum Beispiel Buttons.

Buttons, die nicht zu einem Formular gehören, bekommen `type="button"`. Das heißt: Dieser Knopf schickt nichts ab.

## Deine Aufgabe

Baue unter dem Formular, aber noch innerhalb von `<main>`, eine Liste mit drei Beispielaufgaben, zum Beispiel „Einkaufen gehen“.

Jeder Eintrag enthält in dieser Reihenfolge einen Button „Erledigt“, den Text der Aufgabe und einen Button „Löschen“. Unter die Liste kommt ein weiterer Button mit dem Text „Alle löschen“.

Wenn es geklappt hat, siehst du im Browser drei Zeilen mit einem Punkt davor, jede mit zwei Buttons, und ganz unten den Button „Alle löschen“.

### Wenn es nicht klappt

- **Der Browser zeigt eine Fehlermeldung:** Fast immer fehlt ein schließendes Tag. Zähle nach: Zu jedem `<li>` gehört ein `</li>`, zu `<ul>` ein `</ul>`, zu jedem `<button>` ein `</button>`.
- **Die Einträge haben keinen Punkt davor:** Die `<li>` stehen nicht innerhalb von `<ul>`.
- **Ein Attribut wirkt nicht:** Prüfe das Gleichheitszeichen und beide Anführungszeichen. Zwischen dem Namen des Tags und dem Attribut muss ein Leerzeichen stehen.
- **Die Seite lädt neu, wenn du „Erledigt“ klickst:** Die Liste steht versehentlich innerhalb von `<form>`, und dem Button fehlt `type="button"`. Die Liste gehört unter `</form>`.$lesson$,
    $lesson$```vue [app/app.vue]
<template>
  <main>
    <h1>Meine Aufgaben</h1>
    <p>2 offen</p>

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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'tailwind-einrichten', 'Tailwind einrichten', 'Du richtest Tailwind ein und gibst der Überschrift mit Klassen ein neues Aussehen.', 5, 'css',
    $lesson$Das Gerüst steht. Jetzt beginnt der zweite Durchgang: das Aussehen.

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
- **Das Terminal meldet einen Fehler in `nuxt.config.ts`:** Prüfe Kommas und Klammern. Hinter jeder Zeile im Block steht ein Komma, außer hinter der letzten.$lesson$,
    $lesson$```ts [nuxt.config.ts]
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'die-app-stylen', 'Die App stylen', 'Mit Abständen, Farben, runden Ecken und Flex bekommt die App ihr Layout.', 6, 'css',
    $lesson$In dieser Lektion bekommt die App ihre Form: ein heller Hintergrund, darauf eine weiße Karte mit Formular und Liste.

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
- **Der Rahmen fehlt:** `border-slate-200` allein legt nur die Farbe fest. Du brauchst zusätzlich `border`.$lesson$,
    $lesson$```vue [app/app.vue]
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'icons-mit-lucide', 'Icons mit Lucide', 'Du installierst eine Icon-Sammlung und ersetzt die Texte der Buttons durch Icons.', 7, 'css',
    $lesson$Buttons mit Wörtern brauchen viel Platz. Ein **Icon** ist ein kleines Bildsymbol, das dasselbe sagt, zum Beispiel ein Papierkorb für „Löschen“.

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
- **Das Icon klebt oben links im Button:** Dem Button fehlt `flex` zusammen mit `items-center` und `justify-center`.$lesson$,
    $lesson$```vue [app/app.vue]
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'feinschliff', 'Feinschliff', 'Die App reagiert auf Maus und Tastatur, passt aufs Handy und zeigt erledigte Aufgaben.', 8, 'css',
    $lesson$Jetzt kommen die Kleinigkeiten, die deine App fertig wirken lassen.

## Klassen, die nur manchmal gelten

Bisher gilt jede Klasse immer. Mit einem Wort und einem Doppelpunkt davor gilt sie nur in einer bestimmten Lage. `hover:` heißt: nur solange der Mauszeiger auf dem Tag steht. Diesen Zustand nennt man **Hover**.

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

Probier es aus: Klicke in das Eingabefeld und drücke die Tabulatortaste. Um den Button erscheint ein Ring. In Safari auf dem Mac drückst du dafür Option+Tab. Wer ohne Maus arbeitet, sieht so, wo er gerade ist.

## Das Eingabefeld

Auch das Eingabefeld bekommt solche Klassen. Ergänze sein `class` so:

```vue
class="min-w-0 flex-1 rounded-xl border border-slate-300 px-4 py-2 text-slate-900 placeholder:text-slate-400 focus:border-indigo-600 focus:outline-none"
```

`placeholder:` gilt für den Hinweistext, er wird heller. `focus:` gilt, sobald das Feld ausgewählt ist, egal ob mit Maus oder Tastatur. `focus:outline-none` entfernt den Ring, den der Browser von sich aus zeichnet, und `focus:border-indigo-600` färbt dafür den Rahmen. Was `min-w-0` tut, steht gleich bei der Handy-Ansicht.

Klicke in das Feld: Der Rahmen wird blauviolett.

## Die Ansicht am Handy

Viele Menschen öffnen Webseiten am Handy. Wie deine App dort aussieht, prüfst du am Rechner: Zieh das Browserfenster so schmal wie möglich. Das geht in jedem Browser.

Genauer zeigen es die Entwicklerwerkzeuge. In Chrome, Edge und Firefox öffnest und schließt du sie mit F12, auf dem Mac mit Cmd+Option+I. Dort zeigt ein Knopf mit Handy-Symbol die Seite wie auf einem Handy an.

Die Karte passt sich an. Eng wird es erst bei langen Texten. Dafür gibt es drei Klassen:

- `shrink-0` verbietet einem Tag in einer Flex-Zeile, schmaler zu werden. So bleibt ein Button immer ganz.
- `min-w-0` erlaubt einem Tag in einer Flex-Zeile, schmaler zu werden als sein Inhalt. So ragt nichts aus der Karte.
- `break-words` bricht auch ein sehr langes Wort in die nächste Zeile um.

## Erledigt

Über der Liste steht „2 offen“ bei drei Aufgaben. Eine ist also erledigt, und das soll man sehen. Die Klasse `line-through` streicht einen Text durch.

## Deine Aufgabe

1. Die Papierkörbe und „Alle löschen“ werden rot (`red-600`), wenn die Maus darauf steht, mit weichem Übergang.
2. Die Kreise und die Papierkörbe in der Liste bekommen denselben Tastatur-Ring wie der Button mit dem Plus. Ein offener Kreis bekommt unter der Maus einen blauvioletten Rahmen. Auch die Kreise wechseln ihre Farben weich.
3. Die Kreise dürfen nicht schmaler werden, und ein langer Aufgabentext soll umbrechen, statt aus der Karte zu ragen.
4. Gestalte die erste Aufgabe als erledigt: Der Text ist heller grau und durchgestrichen, der Kreis blauviolett gefüllt mit einem weißen Häkchen. Ihr Kreis heißt jetzt „Als offen markieren“.

Wenn es geklappt hat, sieht die erste Aufgabe abgehakt aus. Ersetze zum Testen einen Aufgabentext durch einen sehr langen und prüfe die schmale Ansicht.

### Wenn es nicht klappt

- **Der Hover wirkt nicht:** Zwischen `hover:` und der Klasse darf kein Leerzeichen stehen. Richtig ist `hover:text-red-600`.
- **Der Kreis der erledigten Aufgabe ist gefüllt, aber leer:** Dort steht noch `text-transparent`. Ersetze es durch `text-white`.
- **Zwei Farben streiten sich:** Stehen an einem Tag zwei Klassen für dieselbe Sache, etwa `border-slate-300` und `border-indigo-600`, gewinnt nicht unbedingt die letzte. Lösche die, die du nicht willst.
- **Der Ring erscheint beim Klicken mit der Maus nicht:** Das soll so sein. `focus-visible:` reagiert bei Buttons nur auf die Tastatur.$lesson$,
    $lesson$Die Reihenfolge der Klassen spielt keine Rolle. Bei den Kreisen stehen hier zuerst die Klassen, die für alle gleich sind, und dahinter die für „offen“ oder „erledigt“.

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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'daten-anzeigen', 'Daten anzeigen', 'Du lernst Variablen, Listen und Objekte kennen und lässt die App ihre Aufgaben aus Daten erzeugen.', 9, 'js',
    $lesson$Der dritte Durchgang beginnt: JavaScript. Bisher steht jede Aufgabe als fester Text im Template. Eine App, in der Aufgaben dazukommen und verschwinden, braucht sie aber als Daten, die sich ändern können. JavaScript verwaltet diese Daten, und das Template zeigt sie an.

## Eine Variable

JavaScript steht in `<script setup>`, wo schon der Import der Icons steht. Eine **Variable** ist ein Name, unter dem sich das Programm einen Wert merkt. Schreib zur Probe unter den Import, mit einer Leerzeile Abstand:

```js
const greeting = ref('Hallo aus JavaScript')
```

`const` kündigt eine neue Variable an. Dahinter steht ihr Name, und nach dem Gleichheitszeichen folgt ihr Wert. Text steht in JavaScript in einfachen Anführungszeichen.

Setze nun im Template direkt unter den Absatz „2 offen“ diese Zeile:

```vue
<p>{{ greeting }}</p>
```

Speichere. Unter „2 offen“ steht „Hallo aus JavaScript“. Doppelte geschweifte Klammern im Template heißen: Zeig an dieser Stelle den Wert der Variable.

## Wozu `ref`?

Um die Anzeige kümmert sich **Vue**, ein Baustein, der in Nuxt steckt. Ein **Ref** ist eine Hülle um einen Wert, die Vue beobachtet: Ändert sich der Wert, zeichnet Vue die betroffenen Stellen der Seite neu. Du erzeugst die Hülle mit `ref` und schreibst den Startwert in die runden Klammern.

Einen Import wie bei den Icons braucht `ref` nicht. Nuxt stellt es in jeder Vue-Datei von selbst bereit.

Lösche die beiden Probezeilen wieder.

## Listen und Objekte

Ein **Array** ist eine Liste von Werten. Sie stehen in eckigen Klammern, getrennt durch Kommas.

Ein **Objekt** bündelt mehrere Werte, die zusammengehören, und gibt jedem einen Namen. Es steht in geschweiften Klammern:

```js
const book = { title: 'Momo', pages: 304, read: true }
```

Dieses Buch hat einen Text, eine Zahl und einen Wahrheitswert. Ein **Wahrheitswert** kennt nur zwei Möglichkeiten: `true` für wahr und `false` für falsch. An einen einzelnen Wert kommst du mit einem Punkt: `book.title` ist der Text „Momo“.

## Ein Tag für jeden Eintrag

Das Attribut `v-for` wiederholt ein Tag für jeden Eintrag eines Arrays. Ein Beispiel, das nicht in die App gehört:

```vue
<script setup>
const names = ref(['Anna', 'Ben', 'Cem'])
</script>

<template>
  <ul>
    <li v-for="name in names" :key="name">{{ name }}</li>
  </ul>
</template>
```

Daraus entstehen drei `<li>`. `name in names` heißt: Geh die Liste `names` durch und nenne den jeweiligen Eintrag `name`. Diesen Namen darfst du innerhalb des Tags benutzen.

Ein Doppelpunkt vor einem Attribut bedeutet: Der Wert ist kein fester Text, sondern JavaScript. `:key` gibt jedem Eintrag ein eindeutiges Kennzeichen, damit Vue die Einträge auseinanderhalten kann.

## Deine Aufgabe

Lege im Script-Teil die Variable `tasks` an: ein Ref mit einem Array aus drei Objekten. Jedes Objekt hat eine `id` (die Zahlen 1, 2 und 3), einen `title` mit dem Text der Aufgabe und ein `done`, das bei der ersten Aufgabe `true` ist und bei den anderen `false`.

Im Template bleibt ein einziges `<li>` übrig. Es wird für jede Aufgabe wiederholt, bekommt die `id` als Kennzeichen und zeigt statt des festen Textes den `title`.

Tipp: Behalte eines der beiden offenen `<li>` und lösche die anderen zwei. Ein Array darf über mehrere Zeilen gehen, am übersichtlichsten ist ein Objekt je Zeile.

Wenn es geklappt hat, zeigt der Browser dieselben drei Aufgaben wie vorher, jetzt alle mit leerem Kreis. Dass die erste nicht mehr erledigt aussieht, ist richtig: Mit `done` verbindest du das Aussehen in der übernächsten Lektion. Änderst du im Script-Teil einen `title`, ändert sich der Eintrag in der Liste.

### Wenn es nicht klappt

- **Die Liste ist leer, oder eine Meldung sagt, `tasks` oder `task` sei nicht definiert:** Ein Name ist an einer Stelle anders geschrieben als an der anderen. `tasks` ist die ganze Liste, `task` der einzelne Eintrag.
- **Alle drei Einträge zeigen denselben Text:** Im `<span>` steht noch der feste Text statt `{{ task.title }}`.
- **Das Terminal oder der Browser meldet einen Fehler im Script-Teil:** Meist fehlt ein Komma zwischen zwei Objekten, eine schließende Klammer oder ein Anführungszeichen.$lesson$,
    $lesson$```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
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
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2"
        >
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 border-slate-300 text-transparent hover:border-indigo-600"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words text-slate-900">{{ task.title }}</span>
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'aufgaben-hinzufuegen', 'Aufgaben hinzufügen', 'Du verbindest das Eingabefeld mit einer Variable und schreibst deine erste Funktion.', 10, 'js',
    $lesson$Die Liste entsteht jetzt aus Daten. Es reicht also, den Daten eine Aufgabe hinzuzufügen, und sie erscheint auf der Seite.

## Das Eingabefeld verbinden

Zuerst muss JavaScript erfahren, was im Eingabefeld steht. Lege unter `tasks` eine zweite Variable an. Zwei Anführungszeichen ohne Inhalt sind ein leerer Text:

```js
const newTask = ref('')
```

Ergänze am `<input>` als erstes Attribut `v-model="newTask"` und setze zur Probe direkt unter `</form>` einen Absatz:

```vue
<p>{{ newTask }}</p>
```

Speichere und tippe etwas in das Feld. Dein Text erscheint Buchstabe für Buchstabe unter dem Formular. `v-model` verbindet ein Eingabefeld in beide Richtungen mit einer Variable: Tippst du, ändert sich die Variable. Ändert sich die Variable, ändert sich der Inhalt des Feldes.

Lösche den Probe-Absatz wieder. `newTask` und `v-model` bleiben.

## Funktionen

Eine **Funktion** ist ein Stück Programm mit einem Namen. Es läuft nicht sofort, sondern erst, wenn die Funktion aufgerufen wird. Ein Beispiel, das nicht in die App gehört:

```js
const numbers = ref([1, 2])

function addThree() {
  numbers.value.push(3)
}
```

Nach dem Wort `function` steht der Name, dann ein Paar runde Klammern, und in den geschweiften Klammern steht, was die Funktion tut.

- Im Script-Teil erreichst du den Inhalt eines Refs über `.value`. Nur im Template lässt du das weg, dort ergänzt Vue es für dich.
- `push` hängt einen Wert ans Ende eines Arrays an.

Ein zweites Beispiel zeigt drei weitere Werkzeuge:

```js
const userName = ref('  Anna ')
const greeting = ref('')

function greet() {
  const name = userName.value.trim()
  if (name === '') return
  greeting.value = 'Hallo ' + name
}
```

- `trim()` liefert einen Text ohne die Leerzeichen an Anfang und Ende. Aus „  Anna “ wird „Anna“.
- `if` prüft eine Bedingung, die in runden Klammern steht. `===` vergleicht zwei Werte und ist wahr, wenn sie gleich sind. `return` beendet die Funktion sofort. Die Zeile heißt also: Ist der Name leer, hör hier auf.
- Mit einem einfachen Gleichheitszeichen gibst du einem Ref einen neuen Wert.

Für die Aufgabe brauchst du außerdem `Date.now()`. Es liefert die aktuelle Uhrzeit als sehr große Zahl, gezählt in Tausendstelsekunden. Weil die Zahl praktisch jedes Mal eine andere ist, eignet sie sich als `id`.

## Auf das Abschicken reagieren

Ein `@` vor einem Attribut heißt: Wenn das hier passiert, ruf diese Funktion auf. So sähe das für die Funktion `greet` aus:

```vue
<form @submit.prevent="greet">
```

`@submit` reagiert auf das Abschicken des Formulars, also auf den Klick auf den Button und auf die Eingabetaste im Feld. Der Zusatz `.prevent` verhindert, dass der Browser dabei die Seite neu lädt, wie du es beim Bau des Gerüsts gesehen hast.

## Deine Aufgabe

Schreib die Funktion `addTask` und lass sie beim Abschicken des Formulars laufen.

Sie hängt an `tasks` ein neues Objekt an. Seine `id` ist eine Zahl, die es noch nicht gibt, sein `title` der getippte Text ohne Leerzeichen am Rand, und `done` ist `false`. Danach leert sie das Eingabefeld. Ist das Feld leer oder enthält es nur Leerzeichen, tut die Funktion nichts.

Tipp: Das Feld leerst du, indem du `newTask` einen leeren Text gibst. Den Rest erledigt `v-model`.

Wenn es geklappt hat, tippst du „Blumen gießen“, drückst die Eingabetaste, und die Aufgabe steht am Ende der Liste. Das Feld ist wieder leer. Ein Klick auf das Plus bei leerem Feld bewirkt nichts.

Nach dem Neuladen der Seite sind deine neuen Aufgaben weg. Das Speichern kommt am Ende des Kurses.

### Wenn es nicht klappt

- **Die Seite lädt beim Abschicken neu:** `.prevent` fehlt, oder das Attribut steht nicht am `<form>`.
- **Beim Abschicken passiert nichts:** Im Script-Teil fehlt ein `.value`. Dort heißt es `tasks.value` und `newTask.value`, nur im Template ohne.
- **Das Feld bleibt nach dem Hinzufügen gefüllt:** Die Zeile, die `newTask` leert, fehlt, oder am `<input>` fehlt `v-model`.
- **Auch leere Aufgaben landen in der Liste:** Die Prüfung mit `if` steht hinter dem `push`, oder sie prüft den Text, bevor die Leerzeichen entfernt sind.$lesson$,
    $lesson$In den geschweiften Klammern des neuen Objekts steht `title` allein. Das ist eine Kurzform von `title: title`: Heißt die Variable genauso wie der Name im Objekt, genügt es, ihn einmal zu schreiben.

```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
const newTask = ref('')

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">2 offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
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
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2"
        >
          <button
            type="button"
            aria-label="Als erledigt markieren"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 border-slate-300 text-transparent hover:border-indigo-600"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words text-slate-900">{{ task.title }}</span>
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'aufgaben-abhaken', 'Aufgaben abhaken', 'Ein Klick auf den Kreis hakt eine Aufgabe ab, und ihr Aussehen richtet sich nach den Daten.', 11, 'js',
    $lesson$Jede Aufgabe trägt den Wert `done` in sich, aber man sieht ihn nicht. In dieser Lektion richtet sich das Aussehen nach `done`, und ein Klick auf den Kreis ändert es.

## Klassen mit Bedingung

Den Doppelpunkt vor einem Attribut kennst du von `:key`: Der Wert ist JavaScript. Vor `class` erlaubt er, Klassen von einer Bedingung abhängig zu machen. Dafür gibt es eine kurze Schreibweise mit Fragezeichen und Doppelpunkt:

```js
task.done ? 'text-slate-400 line-through' : 'text-slate-900'
```

Vorn steht die Bedingung. Ist sie wahr, gilt der Wert hinter dem Fragezeichen, sonst der hinter dem Doppelpunkt.

Ändere das `<span>` mit dem Aufgabentext so:

```vue
<span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
  {{ task.title }}
</span>
```

Die Klassen, die immer gelten, bleiben in `class`. Die Farbe ist nach `:class` gewandert. Ein Tag darf beide Attribute haben, Vue fügt die Klassen zusammen. Achte auf die Anführungszeichen: außen doppelte um das ganze Attribut, innen einfache um die beiden Texte.

Speichere. Die erste Aufgabe ist wieder grau und durchgestrichen, denn ihr `done` ist `true`.

## Auf einen Klick reagieren

`@click` ruft eine Funktion auf, wenn jemand auf das Tag klickt. Dabei kannst du der Funktion etwas mitgeben. Ein **Argument** ist ein Wert, den eine Funktion beim Aufruf bekommt. Sie nimmt ihn unter dem Namen entgegen, der in ihren runden Klammern steht. Ein Beispiel, das nicht in die App gehört:

```vue
<script setup>
const message = ref('')

function greet(name) {
  message.value = 'Hallo ' + name
}
</script>

<template>
  <button type="button" @click="greet('Anna')">Anna grüßen</button>
  <p>{{ message }}</p>
</template>
```

Ein Klick auf den Button ruft `greet` auf, und in der Funktion hat `name` den Wert „Anna“. Statt eines festen Textes kannst du auch eine Variable mitgeben, innerhalb eines `v-for` zum Beispiel einen Wert des aktuellen Eintrags.

## Einen Eintrag finden und einen Wert umdrehen

`find` geht ein Array durch und liefert den ersten Eintrag, für den eine Bedingung wahr ist:

```js
const books = ref([
  { id: 1, title: 'Momo' },
  { id: 2, title: 'Krabat' }
])

const book = books.value.find(book => book.title === 'Krabat')
book.title = 'Krabat, neue Ausgabe'
```

In den Klammern von `find` steht eine Funktion in Kurzform. Vor dem Pfeil `=>` steht der Name für den Eintrag, der gerade geprüft wird, dahinter die Bedingung. `book` ist danach das zweite Objekt, und die letzte Zeile gibt ihm einen neuen Titel. `book` ist ein gewöhnliches Objekt und kein Ref, darum steht dort kein `.value`. Es ist auch keine Kopie: Die Änderung gilt in der Liste.

Ein Ausrufezeichen vor einem Wahrheitswert dreht ihn um. Aus `true` wird `false` und umgekehrt:

```js
const lightOn = ref(true)
lightOn.value = !lightOn.value
```

Nach dieser Zeile ist `lightOn` aus. Führst du sie noch einmal aus, ist es wieder an.

## Deine Aufgabe

1. Schreib die Funktion `checkTask`. Sie bekommt eine `id`, sucht die Aufgabe mit dieser `id` und dreht deren `done` um. Ein Klick auf den Kreis ruft sie mit der `id` der Aufgabe auf.
2. Der Kreis einer erledigten Aufgabe ist gefüllt: `border-indigo-600 bg-indigo-600 text-white`. Der einer offenen ist leer: `border-slate-300 text-transparent hover:border-indigo-600`.
3. Der Name des Kreises für Vorleseprogramme lautet bei einer erledigten Aufgabe „Als offen markieren“, sonst „Als erledigt markieren“.

Tipp: Teile die Klassen des Kreises auf wie beim Text. Was immer gilt, bleibt in `class`, die beiden Zustände kommen nach `:class`. Auch `aria-label` darf einen Doppelpunkt davor und eine Bedingung als Wert bekommen.

Wenn es geklappt hat, füllt ein Klick auf einen leeren Kreis ihn mit einem Häkchen, und der Text wird durchgestrichen. Ein zweiter Klick macht beides rückgängig.

### Wenn es nicht klappt

- **Der Browser zeigt nach der Änderung an `:class` einen Fehler:** Die Anführungszeichen stimmen nicht. Steht innen ein doppeltes, endet das Attribut dort zu früh.
- **Der Klick bewirkt nichts:** `@click` steht nicht am Button mit dem Kreis, oder im Aufruf fehlt `task.id` in den Klammern.
- **Der Text wird durchgestrichen, aber der Kreis bleibt leer:** In `class` stehen noch Klassen für einen Zustand, zum Beispiel `text-transparent`. Sie gehören nur nach `:class`.
- **Der Klick bewirkt nichts, obwohl `@click` stimmt:** In der Funktion steht `task.value.done`. `.value` gehört nur hinter `tasks`. Die gefundene Aufgabe ist ein gewöhnliches Objekt.$lesson$,
    $lesson$```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
const newTask = ref('')

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}

function checkTask(id) {
  const task = tasks.value.find(task => task.id === id)
  task.done = !task.done
}
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">2 offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
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
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2"
        >
          <button
            type="button"
            :aria-label="task.done ? 'Als offen markieren' : 'Als erledigt markieren'"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            :class="task.done ? 'border-indigo-600 bg-indigo-600 text-white' : 'border-slate-300 text-transparent hover:border-indigo-600'"
            @click="checkTask(task.id)"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
            {{ task.title }}
          </span>
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'aufgaben-loeschen', 'Aufgaben löschen', 'Du lernst, wie man Einträge aus einer Liste aussortiert, und bringst den Papierkorb zum Laufen.', 12, 'js',
    $lesson$Hinzufügen und Abhaken funktionieren. Jetzt bekommt der Papierkorb seine Arbeit.

## Aussortieren mit `filter`

`filter` geht ein Array durch und baut ein neues Array aus allen Einträgen, für die eine Bedingung wahr ist. Die Bedingung schreibst du wie bei `find` als Funktion in Kurzform:

```js
const numbers = ref([4, 8, 15, 16, 23])

const big = numbers.value.filter(number => number > 10)
```

Das Zeichen `>` bedeutet „größer als“. `big` ist danach ein Array mit den drei Zahlen 15, 16 und 23.

Der Unterschied zu `find`: `find` liefert einen einzelnen Eintrag, `filter` immer ein Array. Passt kein Eintrag, ist es leer.

Für Bedingungen gibt es mehrere Vergleiche:

- `>` ist wahr, wenn der linke Wert größer ist, `<`, wenn er kleiner ist.
- `===` ist wahr, wenn beide Werte gleich sind.
- `!==` ist wahr, wenn sie verschieden sind. Das Ausrufezeichen steht auch hier für „nicht“.

## Das Ergebnis zuweisen

Wichtig ist, was im Beispiel nicht passiert: `numbers` selbst bleibt, wie es war, mit allen fünf Zahlen. `filter` verändert die Liste nicht, es liefert eine neue.

Sollen die kleinen Zahlen wirklich verschwinden, musst du der Liste das Ergebnis neu zuweisen:

```js
numbers.value = numbers.value.filter(number => number > 10)
```

JavaScript rechnet zuerst aus, was rechts vom Gleichheitszeichen steht. Das Ergebnis legt es dann unter dem alten Namen ab und ersetzt damit die alte Liste. Weil `numbers` ein Ref ist, bemerkt Vue den Wechsel und zeichnet die Seite neu.

Das ist anders als bei `push` aus der Lektion über das Hinzufügen. `push` verändert die vorhandene Liste, darum brauchtest du dort keine Zuweisung. `filter` lässt sie in Ruhe. Die Zuweisung zu vergessen ist der häufigste Fehler in dieser Lektion.

Löschen heißt für JavaScript hier also: Behalte alle außer einem.

## Deine Aufgabe

Schreib die Funktion `deleteTask`. Sie bekommt eine `id` und entfernt die Aufgabe mit dieser `id` aus `tasks`. Verbinde sie mit dem Klick auf den Papierkorb eines Eintrags.

Tipp: Dreh die Frage um. Überlege nicht, welche Aufgabe weg soll, sondern welche bleiben sollen: alle, deren `id` eine andere ist als die übergebene. Den Klick verbindest du so, wie du es beim Kreis getan hast.

Wenn es geklappt hat, verschwindet ein Eintrag, sobald du auf seinen Papierkorb klickst. Die anderen bleiben stehen. Lösch ruhig alle drei: Nach dem Neuladen der Seite sind die Beispielaufgaben wieder da.

Die Zahl über der Liste stimmt jetzt nicht mehr, dort steht weiter „2 offen“. Darum kümmerst du dich in der nächsten Lektion.

### Wenn es nicht klappt

- **Der Klick bewirkt nichts:** Das Ergebnis von `filter` wird nicht zugewiesen. Vorn muss `tasks.value =` stehen. Oder im Aufruf am Button fehlt `task.id` in den Klammern.
- **Die angeklickte Aufgabe bleibt, alle anderen verschwinden:** In der Bedingung steht `===` statt `!==`.
- **Ein Klick auf den Kreis löscht die Aufgabe:** `@click` mit `deleteTask` steht am falschen Button. Es gehört an den mit dem Papierkorb.
- **Eine Meldung sagt, `filter` sei keine Funktion:** Es fehlt `.value` hinter `tasks`.$lesson$,
    $lesson$```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
const newTask = ref('')

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}

function checkTask(id) {
  const task = tasks.value.find(task => task.id === id)
  task.done = !task.done
}

function deleteTask(id) {
  tasks.value = tasks.value.filter(task => task.id !== id)
}
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">2 offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
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
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2"
        >
          <button
            type="button"
            :aria-label="task.done ? 'Als offen markieren' : 'Als erledigt markieren'"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            :class="task.done ? 'border-indigo-600 bg-indigo-600 text-white' : 'border-slate-300 text-transparent hover:border-indigo-600'"
            @click="checkTask(task.id)"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
            {{ task.title }}
          </span>
          <button
            type="button"
            aria-label="Aufgabe löschen"
            class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            @click="deleteTask(task.id)"
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'zaehler-und-leere-liste', 'Zähler und leere Liste', 'Die App zählt ihre offenen Aufgaben selbst und zeigt einen Hinweis, wenn die Liste leer ist.', 13, 'js',
    $lesson$Zwei Stellen der App stimmen noch nicht. Über der Liste steht immer „2 offen“, egal wie viele Aufgaben offen sind. Und wenn du alle Aufgaben löschst, bleibt eine leere Fläche zurück.

## Anzeigen unter einer Bedingung

Das Attribut `v-if` zeigt ein Tag nur dann an, wenn eine Bedingung wahr ist. Bekommt das direkt folgende Tag `v-else`, erscheint es genau dann, wenn die Bedingung falsch ist. Von den beiden ist also immer eines zu sehen.

Für die Bedingung brauchst du `length`. Es liefert die Anzahl der Einträge eines Arrays.

Setze direkt über das `<ul>` einen Absatz:

```vue
<p v-if="tasks.length === 0" class="mt-6 text-center text-slate-500">
  Noch keine Aufgaben. Leg los!
</p>
```

Ergänze dann am `<ul>` als erstes Attribut `v-else`:

```vue
<ul v-else class="mt-6 space-y-2">
```

Die Klasse `text-center` rückt den Text in die Mitte.

Speichere. Zunächst sieht alles aus wie vorher, denn die Liste hat drei Einträge. Lösche alle drei mit dem Papierkorb: Statt der Liste erscheint der Hinweis „Noch keine Aufgaben. Leg los!“. Füge eine Aufgabe hinzu, und der Hinweis macht der Liste wieder Platz.

Zwischen dem Tag mit `v-if` und dem mit `v-else` darf kein anderes Tag stehen.

## Werte, die sich selbst berechnen

Die Zahl der offenen Aufgaben ist kein eigener Wert, den du pflegen musst. Sie ergibt sich aus der Liste. Für solche Fälle gibt es `computed`. Ein **berechneter Wert** entsteht aus anderen Werten, und Vue hält ihn von selbst aktuell. Ein Beispiel, das nicht in die App gehört:

```vue
<script setup>
const price = ref(4)
const amount = ref(3)

const total = computed(() => price.value * amount.value)
</script>

<template>
  <p>Summe: {{ total }}</p>
</template>
```

In den Klammern von `computed` steht wieder eine Funktion in Kurzform. Sie braucht keinen Eintrag zum Prüfen, darum bleiben die runden Klammern vor dem Pfeil leer. Hinter dem Pfeil steht die Rechnung, das Sternchen bedeutet „mal“.

Die Seite zeigt „Summe: 12“. Bekommt `amount` später den Wert 5, steht dort ohne dein Zutun „Summe: 20“.

## Der Unterschied zu einer Funktion

Eine Funktion läuft nur, wenn sie aufgerufen wird. Für die Summe müsstest du also an jeder Stelle, die Preis oder Menge ändert, daran denken, neu zu rechnen.

Einen berechneten Wert schreibst du einmal hin. Vue merkt sich, welche Refs in der Rechnung vorkommen, und rechnet neu, sobald sich einer davon ändert. Benutzt wird er wie eine Variable: im Template nur mit dem Namen, im Script-Teil mit `.value`.

Auch `computed` stellt Nuxt von selbst bereit.

## Deine Aufgabe

Lege `openCount` als berechneten Wert an: die Anzahl der Aufgaben, die nicht erledigt sind. Zeige ihn über der Liste an, anstelle der festen 2 in „2 offen“.

Tipp: `filter` aus der letzten Lektion liefert dir alle offenen Aufgaben, `length` ihre Anzahl. Wie du aus „erledigt“ ein „nicht erledigt“ machst, weißt du seit dem Abhaken.

Wenn es geklappt hat, steht nach dem Laden weiter „2 offen“ da. Hakst du eine Aufgabe ab, wird daraus „1 offen“. Fügst du eine hinzu, steigt die Zahl, und löschst du eine offene, sinkt sie.

### Wenn es nicht klappt

- **Statt einer Zahl steht ein Stück Programm auf der Seite:** `computed` fehlt, und `openCount` ist nur eine Funktion. Die Kurzform gehört in die Klammern von `computed`.
- **Eine Meldung sagt, `filter` sei keine Funktion:** In der Rechnung fehlt `.value` hinter `tasks`.
- **Die Zahl zählt die erledigten Aufgaben:** In der Bedingung fehlt das Ausrufezeichen vor `task.done`.
- **Der Browser meldet einen Fehler zu `v-else`:** Zwischen dem Absatz mit `v-if` und dem `<ul>` steht ein anderes Tag.$lesson$,
    $lesson$```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Check, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
const newTask = ref('')

const openCount = computed(() => tasks.value.filter(task => !task.done).length)

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}

function checkTask(id) {
  const task = tasks.value.find(task => task.id === id)
  task.done = !task.done
}

function deleteTask(id) {
  tasks.value = tasks.value.filter(task => task.id !== id)
}
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">{{ openCount }} offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
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

      <p v-if="tasks.length === 0" class="mt-6 text-center text-slate-500">
        Noch keine Aufgaben. Leg los!
      </p>
      <ul v-else class="mt-6 space-y-2">
        <li
          v-for="task in tasks"
          :key="task.id"
          class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2"
        >
          <button
            type="button"
            :aria-label="task.done ? 'Als offen markieren' : 'Als erledigt markieren'"
            class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            :class="task.done ? 'border-indigo-600 bg-indigo-600 text-white' : 'border-slate-300 text-transparent hover:border-indigo-600'"
            @click="checkTask(task.id)"
          >
            <Check class="size-4" />
          </button>
          <span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
            {{ task.title }}
          </span>
          <button
            type="button"
            aria-label="Aufgabe löschen"
            class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
            @click="deleteTask(task.id)"
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'in-komponenten-aufteilen', 'In Komponenten aufteilen', 'Du lagerst den Listeneintrag in eine eigene Datei aus und lässt beide Dateien miteinander sprechen.', 14, 'js',
    $lesson$`app/app.vue` ist lang geworden. Eine **Komponente** ist ein Stück Seite in einer eigenen Vue-Datei, das du wie ein Tag benutzt. Du kennst das schon von den Icons. Jede Datei hat dann eine einzige Aufgabe, und du findest schneller, was du suchst.

## Eine eigene Komponente

Klicke in VS Code mit der rechten Maustaste auf den Ordner `app`, wähle „New File“ („Neue Datei“) und tippe `components/TaskItem.vue`. In die Datei kommt:

```vue [app/components/TaskItem.vue]
<script setup>
defineProps({
  task: { type: Object, required: true }
})
</script>

<template>
  <li>{{ task.title }}</li>
</template>
```

Ein **Prop** ist ein Wert, den eine Komponente von außen bekommt, geschrieben wie ein Attribut. `defineProps` zählt die Props auf. Hier ist es eines: Es heißt `task`, muss ein Objekt sein und darf nicht fehlen.

Setze jetzt in `app/app.vue` direkt über das `<li>` diese Zeile:

```vue
<TaskItem v-for="task in tasks" :key="task.id" :task="task" />
```

`:task="task"` reicht die jeweilige Aufgabe in die Komponente hinein. Einen Import brauchst du nicht: Nuxt stellt jede Datei aus `app/components` unter ihrem Dateinamen bereit.

Speichere beide Dateien. Über den drei Einträgen stehen ihre Titel noch einmal als schlichter Text. Die Komponente funktioniert.

## Nach oben melden

Die Liste `tasks` und die Funktionen dazu bleiben in `app/app.vue`. Die Komponente kennt sie nicht und ändert auch nichts selbst. Sie meldet nur, was passiert ist. Ein **Event** ist eine Nachricht, die eine Komponente nach oben schickt.

Ein Beispiel, das nicht in die App gehört, eine Komponente `ColorButton.vue`:

```vue
<script setup>
defineEmits(['choose'])
</script>

<template>
  <button type="button" @click="$emit('choose', 'Rot')">Rot</button>
</template>
```

`defineEmits` zählt die Namen der Events auf, die die Komponente schicken kann. `$emit` schickt eines ab: zuerst der Name, danach ein Wert, der mitreist.

Wer die Komponente benutzt, hört auf das Event wie auf einen Klick:

```vue
<ColorButton @choose="setColor" />
```

Steht hinter dem Event nur der Name einer Funktion, bekommt sie den mitgeschickten Wert als Argument. `setColor` wird hier also mit „Rot“ aufgerufen.

## Deine Aufgabe

Stelle `TaskItem` fertig. Verschiebe das ganze `<li>` mit Kreis, Text und Papierkorb aus `app/app.vue` in die Komponente. Dort melden die beiden Buttons ihre Klicks mit den Events `check` und `delete` und schicken jeweils die `id` der Aufgabe mit. In `app/app.vue` verbindest du die Events mit `checkTask` und `deleteTask`.

Tipps:

- Ausschneiden und Einfügen spart Tipparbeit. In der Komponente ersetzt das verschobene `<li>` das bisherige.
- `v-for` und `:key` gehören in `app/app.vue` an `<TaskItem>`. Am `<li>` in der Komponente löschst du sie.
- Jede Datei importiert die Icons, die in ihrem eigenen Template vorkommen. Prüfe beide Importe.
- Bei vielen Attributen darfst du sie auch an `<TaskItem>` untereinander schreiben.

Wenn es geklappt hat, sieht die App genauso aus wie vor dieser Lektion, und Abhaken und Löschen funktionieren wie bisher. Nur `app/app.vue` ist deutlich kürzer.

### Wenn es nicht klappt

- **Die Kreise sind leer, oder die Papierkörbe fehlen:** In `TaskItem.vue` fehlt der Import der Icons.
- **Die Klicks bewirken nichts:** Der Name des Events muss an drei Stellen gleich geschrieben sein: in `defineEmits`, in `$emit` und hinter dem `@` in `app/app.vue`. Oder es fehlt `task.id` als zweiter Wert in `$emit`.
- **Die Liste bleibt leer, und eine Meldung sagt, `TaskItem` sei nicht bekannt:** Die Datei liegt nicht in `app/components` oder heißt anders. Stimmt beides, stoppe den Entwicklungsserver und starte ihn neu.
- **Eine Meldung nennt `checkTask`:** Die Komponente ruft die Funktion noch direkt auf. Sie kennt nur ihr Prop und ihre Events.$lesson$,
    $lesson$```vue [app/components/TaskItem.vue]
<script setup>
import { Check, Trash2 } from '@lucide/vue'

defineProps({
  task: { type: Object, required: true }
})

defineEmits(['check', 'delete'])
</script>

<template>
  <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
    <button
      type="button"
      :aria-label="task.done ? 'Als offen markieren' : 'Als erledigt markieren'"
      class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      :class="task.done ? 'border-indigo-600 bg-indigo-600 text-white' : 'border-slate-300 text-transparent hover:border-indigo-600'"
      @click="$emit('check', task.id)"
    >
      <Check class="size-4" />
    </button>
    <span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
      {{ task.title }}
    </span>
    <button
      type="button"
      aria-label="Aufgabe löschen"
      class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      @click="$emit('delete', task.id)"
    >
      <Trash2 class="size-4" />
    </button>
  </li>
</template>
```

```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Trash2 } from '@lucide/vue'

const tasks = ref([
  { id: 1, title: 'Einkaufen gehen', done: true },
  { id: 2, title: 'Wäsche waschen', done: false },
  { id: 3, title: 'Oma anrufen', done: false }
])
const newTask = ref('')

const openCount = computed(() => tasks.value.filter(task => !task.done).length)

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}

function checkTask(id) {
  const task = tasks.value.find(task => task.id === id)
  task.done = !task.done
}

function deleteTask(id) {
  tasks.value = tasks.value.filter(task => task.id !== id)
}
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">{{ openCount }} offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
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

      <p v-if="tasks.length === 0" class="mt-6 text-center text-slate-500">
        Noch keine Aufgaben. Leg los!
      </p>
      <ul v-else class="mt-6 space-y-2">
        <TaskItem
          v-for="task in tasks"
          :key="task.id"
          :task="task"
          @check="checkTask"
          @delete="deleteTask"
        />
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
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'speichern-im-browser', 'Speichern im Browser', 'Die App merkt sich deine Aufgaben, auch wenn du die Seite neu lädst oder den Browser schließt.', 15, 'js',
    $lesson$Nach jedem Neuladen sind wieder die drei Beispielaufgaben da. Das änderst du jetzt.

## Der Speicher des Browsers

**`localStorage`** ist ein kleiner Speicher, den der Browser für jede Website führt. Was dort liegt, übersteht das Neuladen und das Schließen des Browsers. Er merkt sich Texte unter einem Namen. Ein Beispiel, das nicht in die App gehört:

```js
localStorage.setItem('color', 'Blau')
const color = localStorage.getItem('color')
```

`setItem` legt einen Text unter einem Namen ab, `getItem` holt ihn wieder. Liegt unter dem Namen nichts, liefert `getItem` den Wert `null`, das heißt „nichts“.

Eine Liste ist kein Text. Dafür gibt es zwei Übersetzer: `JSON.stringify` macht aus einem Array oder Objekt einen Text, `JSON.parse` macht daraus wieder ein Array oder Objekt. Wieder nur ein Beispiel:

```js
const text = JSON.stringify(['Rot', 'Blau'])
const colors = JSON.parse(text)
```

## Bei jeder Änderung speichern

`watch` beobachtet ein Ref und ruft bei jeder Änderung eine Funktion auf. Schreib ans Ende des Script-Teils von `app/app.vue`:

```js
watch(tasks, () => {
  localStorage.setItem('tasks', JSON.stringify(tasks.value))
}, { deep: true })
```

In den Klammern stehen das beobachtete Ref, die Funktion und eine Einstellung. `deep: true` heißt, dass Vue auch in die Liste hineinschaut. So zählt nicht nur eine ausgetauschte Liste als Änderung, sondern auch eine neue Aufgabe oder ein umgedrehtes `done`. Auch `watch` stellt Nuxt von selbst bereit, genau wie `onMounted`, das gleich folgt.

Speichere und hake eine Aufgabe ab. Vom Speichern selbst siehst du auf der Seite nichts, wohl aber in den Entwicklerwerkzeugen: Öffne sie wie beim Feinschliff und such den Bereich für gespeicherte Daten. In Chrome und Edge heißt er „Application“, in Firefox „Web-Speicher“, bei dir vielleicht etwas anders. Unter „Local Storage“ und der Adresse deiner App steht ein Eintrag `tasks` mit deiner Liste als Text.

Lade die Seite neu. Trotzdem erscheinen wieder die Beispielaufgaben, denn gespeichert wird schon, geladen noch nicht.

## Laden, sobald die Seite im Browser ist

Naheliegend wäre, den Speicher gleich oben im Script-Teil auszulesen. Das scheitert. Nuxt baut die Seite zuerst auf dem Server zusammen, also in dem Programm, das in deinem Terminal läuft, und schickt sie fertig an den Browser. Der Server hat keinen Zugriff auf den Speicher deines Browsers, und die Seite bräche mit einem Fehler ab.

`onMounted` löst das. Es bekommt eine Funktion, und die läuft nur im Browser, sobald die Seite dort angezeigt wird. Ein Beispiel, das nicht in die App gehört:

```js
const message = ref('')

onMounted(() => {
  message.value = 'Jetzt bin ich im Browser'
})
```

Bei `watch` gibt es das Problem nicht: Seine Funktion läuft erst, wenn sich im Browser etwas ändert.

## Deine Aufgabe

1. Lade in `onMounted` den Text, der unter `tasks` gespeichert ist. Gibt es einen, wandle ihn zurück und weise ihn `tasks` zu.
2. Ersetze die drei Beispielaufgaben durch ein leeres Array, also zwei eckige Klammern ohne Inhalt.
3. Schreib die Funktion `clearTasks`, die die Liste leert, und verbinde sie mit dem Klick auf „Alle löschen“. Der Button ist nur zu sehen, wenn es mindestens eine Aufgabe gibt.

Tipp: Ob etwas gespeichert war, prüfst du mit `if` und dem geladenen Wert in den Klammern, ganz ohne Vergleich. `null` zählt als falsch, jeder gespeicherte Text als wahr. Für den Button kennst du `v-if`, `length` und „größer als“.

Wenn es geklappt hat, bleiben deine Aufgaben nach dem Neuladen stehen, samt Häkchen. Auch die drei Beispielaufgaben sind noch da: Sie kommen jetzt aus dem Speicher. Mit „Alle löschen“ wirst du sie los. Dann erscheint der Hinweis, und der Button verschwindet.

### Wenn es nicht klappt

- **Eine Fehlermeldung nennt `localStorage`:** Der Zugriff steht direkt im Script-Teil statt in der Funktion von `onMounted`.
- **Nach dem Neuladen ist die Liste leer:** Der Name in `getItem` ist anders geschrieben als der in `setItem`, oder die Zuweisung an `tasks.value` fehlt.
- **Neue Aufgaben und Häkchen werden erst gespeichert, wenn du eine Aufgabe löschst:** Bei `watch` fehlt `{ deep: true }`.$lesson$,
    $lesson$```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Trash2 } from '@lucide/vue'

const tasks = ref([])
const newTask = ref('')

const openCount = computed(() => tasks.value.filter(task => !task.done).length)

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}

function checkTask(id) {
  const task = tasks.value.find(task => task.id === id)
  task.done = !task.done
}

function deleteTask(id) {
  tasks.value = tasks.value.filter(task => task.id !== id)
}

function clearTasks() {
  tasks.value = []
}

onMounted(() => {
  const saved = localStorage.getItem('tasks')
  if (saved) tasks.value = JSON.parse(saved)
})

watch(tasks, () => {
  localStorage.setItem('tasks', JSON.stringify(tasks.value))
}, { deep: true })
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">{{ openCount }} offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
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

      <p v-if="tasks.length === 0" class="mt-6 text-center text-slate-500">
        Noch keine Aufgaben. Leg los!
      </p>
      <ul v-else class="mt-6 space-y-2">
        <TaskItem
          v-for="task in tasks"
          :key="task.id"
          :task="task"
          @check="checkTask"
          @delete="deleteTask"
        />
      </ul>

      <button
        v-if="tasks.length > 0"
        type="button"
        class="mt-6 flex items-center gap-2 text-sm text-slate-500 transition-colors hover:text-red-600"
        @click="clearTasks"
      >
        <Trash2 class="size-4" />
        Alle löschen
      </button>
    </div>
  </main>
</template>
```$lesson$,
    true
  ),
  (
    (select id from public.courses where slug = 'todo-app'),
    'geschafft', 'Geschafft', 'Ein Rückblick auf alles, was du gebaut hast, fünf Ideen zum Weitermachen und der vollständige Code.', 16, 'abschluss',
    $lesson$Deine Aufgabenliste ist fertig. Du hast sie Zeile für Zeile selbst gebaut, und sie läuft auf deinem eigenen Rechner. Schau kurz zurück, was dabei alles zusammengekommen ist.

## Was du gelernt hast

Mit **HTML** hast du beschrieben, was auf der Seite steht. Du kennst Tags und Attribute, hast ein Formular mit Eingabefeld und Button gebaut und eine Liste mit Einträgen. Du weißt, dass Tags ineinander stecken und dass ein vergessenes schließendes Tag die häufigste Fehlerquelle ist.

Mit **CSS** hast du der Seite ihr Aussehen gegeben. Dank Tailwind brauchtest du dafür keine eigene Datei voller Regeln, sondern kleine Klassen direkt am Tag: für Farben, Abstände, runde Ecken und das Nebeneinander mit Flex. Dazu kamen Icons, der Zustand unter der Maus, der Ring für die Tastatur und eine Ansicht, die auch am Handy passt.

Mit **JavaScript** hast du die Seite zum Leben erweckt. Die Aufgaben sind Daten in einem Ref, das Template zeigt sie an, und Funktionen ändern sie: hinzufügen, abhaken, löschen. Ein berechneter Wert zählt mit, eine Komponente hält den Code übersichtlich, und der Speicher des Browsers merkt sich alles. Das sind dieselben Bausteine, aus denen auch große Web-Apps bestehen.

## Ideen zum Weitermachen

Am meisten lernst du jetzt, wenn du die App nach deinen eigenen Wünschen umbaust. Fünf Vorschläge, vom leichten zum schweren:

1. **Ein eigenes Farbschema.** Ersetze überall `indigo` durch eine andere Farbe von Tailwind, zum Beispiel `emerald` oder `rose`, und probiere einen anderen Hintergrund aus.
2. **Ein Filter für offene und erledigte Aufgaben.** Drei Buttons „Alle“, „Offen“ und „Erledigt“ setzen ein Ref, und ein berechneter Wert liefert mit `filter` die passende Liste für das `v-for`.
3. **Ein Fälligkeitsdatum.** Ein `<input>` mit `type="date"` liefert ein Datum, das du als weiteren Wert im Objekt der Aufgabe ablegst und im Eintrag anzeigst.
4. **Aufgaben bearbeiten.** Ein Klick auf den Text macht aus ihm ein Eingabefeld mit `v-model`, und die Eingabetaste übernimmt die Änderung. Dafür braucht `TaskItem` ein drittes Event.
5. **Die App veröffentlichen.** Bisher läuft sie nur auf deinem Rechner. Es gibt Anbieter, bei denen kleine Projekte kostenlos im Internet stehen dürfen. Die Anleitung von Nuxt auf `https://nuxt.com` beschreibt unter dem Stichwort „Deployment“, wie das geht.

Wenn etwas nicht klappt, geh vor wie im Kurs: eine kleine Änderung, speichern, im Browser nachsehen. Und wenn du dich verrennst, hilft dir der Code unten zurück auf einen Stand, der funktioniert.

## Der vollständige Code

Das sind alle vier Dateien, die du im Kurs geschrieben oder geändert hast, im Stand nach der letzten Lektion. Alles andere im Projektordner hat Nuxt beim Anlegen selbst erzeugt.

Die Einstellungen für Nuxt:

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

Die CSS-Datei, die Tailwind einschaltet:

```css [app/assets/css/main.css]
@import "tailwindcss";
```

Die Seite mit den Daten und den Funktionen:

```vue [app/app.vue]
<script setup>
import { ListTodo, Plus, Trash2 } from '@lucide/vue'

const tasks = ref([])
const newTask = ref('')

const openCount = computed(() => tasks.value.filter(task => !task.done).length)

function addTask() {
  const title = newTask.value.trim()
  if (title === '') return
  tasks.value.push({ id: Date.now(), title, done: false })
  newTask.value = ''
}

function checkTask(id) {
  const task = tasks.value.find(task => task.id === id)
  task.done = !task.done
}

function deleteTask(id) {
  tasks.value = tasks.value.filter(task => task.id !== id)
}

function clearTasks() {
  tasks.value = []
}

onMounted(() => {
  const saved = localStorage.getItem('tasks')
  if (saved) tasks.value = JSON.parse(saved)
})

watch(tasks, () => {
  localStorage.setItem('tasks', JSON.stringify(tasks.value))
}, { deep: true })
</script>

<template>
  <main class="min-h-screen bg-slate-100 px-4 py-10">
    <div class="mx-auto max-w-md rounded-2xl bg-white p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <ListTodo class="size-7 text-indigo-600" />
        <h1 class="text-2xl font-bold text-slate-900">Meine Aufgaben</h1>
      </div>
      <p class="mt-1 text-sm text-slate-500">{{ openCount }} offen</p>

      <form class="mt-6 flex gap-2" @submit.prevent="addTask">
        <input
          v-model="newTask"
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

      <p v-if="tasks.length === 0" class="mt-6 text-center text-slate-500">
        Noch keine Aufgaben. Leg los!
      </p>
      <ul v-else class="mt-6 space-y-2">
        <TaskItem
          v-for="task in tasks"
          :key="task.id"
          :task="task"
          @check="checkTask"
          @delete="deleteTask"
        />
      </ul>

      <button
        v-if="tasks.length > 0"
        type="button"
        class="mt-6 flex items-center gap-2 text-sm text-slate-500 transition-colors hover:text-red-600"
        @click="clearTasks"
      >
        <Trash2 class="size-4" />
        Alle löschen
      </button>
    </div>
  </main>
</template>
```

Die Komponente für einen einzelnen Eintrag:

```vue [app/components/TaskItem.vue]
<script setup>
import { Check, Trash2 } from '@lucide/vue'

defineProps({
  task: { type: Object, required: true }
})

defineEmits(['check', 'delete'])
</script>

<template>
  <li class="flex items-center gap-3 rounded-xl border border-slate-200 px-3 py-2">
    <button
      type="button"
      :aria-label="task.done ? 'Als offen markieren' : 'Als erledigt markieren'"
      class="flex size-6 shrink-0 items-center justify-center rounded-full border transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      :class="task.done ? 'border-indigo-600 bg-indigo-600 text-white' : 'border-slate-300 text-transparent hover:border-indigo-600'"
      @click="$emit('check', task.id)"
    >
      <Check class="size-4" />
    </button>
    <span class="min-w-0 flex-1 break-words" :class="task.done ? 'text-slate-400 line-through' : 'text-slate-900'">
      {{ task.title }}
    </span>
    <button
      type="button"
      aria-label="Aufgabe löschen"
      class="text-slate-400 transition-colors hover:text-red-600 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      @click="$emit('delete', task.id)"
    >
      <Trash2 class="size-4" />
    </button>
  </li>
</template>
```$lesson$,
    null,
    true
  )
on conflict (course_id, slug) do update set
  title = excluded.title,
  summary = excluded.summary,
  position = excluded.position,
  section = excluded.section,
  content = excluded.content,
  solution = excluded.solution,
  published = excluded.published;
