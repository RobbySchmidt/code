# Mehrere Kurse – Design

Stand: 2026-10-06

Dieses Dokument ergänzt `2026-10-05-nuxt-kursseite-design.md`. Es ersetzt dort die Abschnitte „Seiten“, „Kurs weitermachen“, „Datenmodell“ und „Kursinhalt“. Gestaltung, Konten, Fehlerfälle und offene Punkte gelten unverändert weiter.

## Ziel

Die Seite trägt mehrere Kurse statt eines einzigen. Nicht jeder will eine Todo-App bauen; später kommen weitere Projektkurse dazu, zum Beispiel eine Galerie. Fortschritt und „Kurs weitermachen“ gelten pro Kurs.

## Umfang

Enthalten:

- Umbau der Plattform auf mehrere Kurse (Datenbank, Seiten, Fortschritt, Profil)
- Kurs „Erste Schritte“ (3 Lektionen)
- Kurs „Todo-App“ (16 Lektionen)

Nicht enthalten:

- Kurs „Galerie“ (eigener späterer Schritt)
- Sperren von Kursen, bis ein anderer abgeschlossen ist
- Admin-Bereich; Kurse und Lektionen werden weiter im Supabase-Dashboard gepflegt

## Seiten

| Seite | Inhalt |
|---|---|
| `/` | Vorstellung der Seite, Button „Kurse ansehen“, darunter die Kurse als Karten |
| `/kurse` | Alle veröffentlichten Kurse als Karten mit Titel, Kurzbeschreibung und Anzahl der Lektionen. Eingeloggt zusätzlich der Fortschritt pro Kurs. |
| `/kurse/[kurs]` | Ein Kurs: Titel, Kurzbeschreibung, Hinweis auf den empfohlenen Kurs, eingeloggt Fortschrittsbalken, „Kurs weitermachen“ und die Lektionsliste nach Blöcken mit „x von y erledigt“ und Abschlussdatum |
| `/kurse/[kurs]/[lektion]` | Eine Lektion wie bisher; die Seitenleiste zeigt die Lektionen dieses Kurses, „Zurück“/„Weiter“ bleiben innerhalb des Kurses |
| `/profil` | Konto (E-Mail, Passwort ändern, Abmelden) und „Deine Kurse“: jeder begonnene Kurs mit Fortschritt und „Kurs weitermachen“ |

`/lektionen` und `/kurs/[slug]` entfallen. Im Menü steht „Kurse“. Nach Login und nach der Kontobestätigung landet man auf `/kurse`; der Rücksprung über `?weiter=` bleibt.

Ein Kurs gilt als begonnen, wenn mindestens eine seiner Lektionen abgeschlossen oder geöffnet wurde.

### Kopfzeile

Die Kopfzeile bleibt beim Scrollen oben stehen. Abweichend von der Regel „Ember nur für die Hauptaktion“ gilt für die Kopfzeile: Menü-Links werden bei Hover und auf der aktiven Seite Ember, ohne Unterstreichung, und „Abmelden“ ist ein Ember-gefüllter Button wie „Konto erstellen“. „Kurse“ ist auch auf Kurs- und Lektionsseiten als aktiv markiert. Beim Seitenwechsel blendet die alte Seite kurz aus und die neue ein; bei reduzierter Bewegung entfällt der Effekt.

### Kurs weitermachen

Die Regeln gelten unverändert, aber je Kurs und nur mit den Lektionen dieses Kurses:

1. zur zuletzt geöffneten Lektion des Kurses, wenn sie veröffentlicht und noch nicht abgeschlossen ist,
2. sonst zur ersten noch nicht abgeschlossenen Lektion des Kurses,
3. sind alle Lektionen des Kurses abgeschlossen: „Kurs abgeschlossen“ mit Link zur letzten Lektion.

Wer im Kurs noch nichts geöffnet hat, sieht „Kurs starten“.

### Empfohlener Kurs

Ein Kurs kann einen anderen als Einstieg empfehlen. Die Kursseite zeigt dann einen Hinweis mit Link, zum Beispiel „Neu hier? Mach zuerst den Kurs ‚Erste Schritte‘“. Der Hinweis entfällt, wenn der eingeloggte Nutzer den empfohlenen Kurs vollständig abgeschlossen hat. Gesperrt wird nichts.

## Datenmodell

### `public.courses` (neu)

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | `bigint`, Identity, Primärschlüssel | |
| `slug` | `text`, eindeutig, nicht leer | Adressteil, z. B. `todo-app` |
| `title` | `text`, nicht leer | |
| `summary` | `text`, nicht leer | Kurzbeschreibung für Karte und Kursseite |
| `position` | `integer`, eindeutig | Reihenfolge der Kurse |
| `recommended_course_id` | `bigint`, darf `null` sein, Verweis auf `courses`, `on delete set null` | Empfohlener Einstieg |
| `published` | `boolean`, Standard `false` | |
| `created_at`, `updated_at` | `timestamptz`, Standard `now()` | `updated_at` per Trigger |

### `public.lessons` (geändert)

- Neue Spalte `course_id`, `bigint`, nicht leer, Verweis auf `courses`, `on delete cascade`.
- `slug` und `position` sind nur noch innerhalb eines Kurses eindeutig: `(course_id, slug)` und `(course_id, position)`.
- Alle anderen Spalten bleiben. Die Blöcke bleiben `start`, `html`, `css`, `js`, `abschluss`; ein Kurs zeigt nur die Blöcke, die er benutzt.

### `public.lesson_progress`

Unverändert.

### `public.course_state` (neu, ersetzt `profiles`)

| Spalte | Typ | Hinweis |
|---|---|---|
| `user_id` | `uuid`, Verweis auf `auth.users`, `on delete cascade` | |
| `course_id` | `bigint`, Verweis auf `courses`, `on delete cascade` | |
| `last_lesson_id` | `bigint`, darf `null` sein, Verweis auf `lessons`, `on delete set null` | Zuletzt geöffnete Lektion des Kurses |
| `updated_at` | `timestamptz`, Standard `now()` | |

Primärschlüssel ist `(user_id, course_id)`. Die Zeile entsteht beim ersten Öffnen einer Lektion des Kurses per Upsert. Die Tabelle `profiles` wird gelöscht.

### Zugriffsregeln (RLS)

RLS ist auf allen Tabellen aktiv.

- `courses`: `select` für `anon` und `authenticated`, nur `published = true`. Kein Schreiben.
- `lessons`: `select` für `anon` und `authenticated`, nur wenn die Lektion **und** ihr Kurs veröffentlicht sind. Kein Schreiben.
- `lesson_progress`: unverändert.
- `course_state`: `select`, `insert` und `update` für `authenticated`, jeweils nur mit `user_id = auth.uid()`. Kein `delete`.

### Umstellung

Die Seite ist nicht öffentlich und enthält nur Testdaten. Die Migration löscht die Beispiel-Lektionen und damit den vorhandenen Testfortschritt.

## Kursinhalt

### Pflege

Wie bisher: Das Schema liegt als Migration im Repo. Die Kurse und Lektionstexte liegen als SQL-Datei in `supabase/seeds/courses.sql` und werden genau einmal eingespielt; danach ist die Datenbank die maßgebliche Quelle.

### Aufbau einer Lektion

Jede Lektion mit Code hat drei Teile:

1. **Erklärung** des Neuen an einem kleinen Beispiel.
2. **„Deine Aufgabe“**: ein Schritt an der eigenen App, den man selbst löst. Der Text verrät den fertigen Code dafür nicht.
3. **Musterlösung** zum Aufklappen mit dem vollständigen Stand der geänderten Dateien.

Lektionen ohne Code haben keine Musterlösung.

`{{ }}` und Attribute mit `:` oder `@` stehen im Lektionstext immer in Code-Auszeichnung, weil der Markdown-Renderer sie sonst als Befehle liest.

### Kurs „Erste Schritte“ (`erste-schritte`)

Alle Lektionen im Block Start.

1. **Willkommen:** Wie die Kurse funktionieren und was man braucht
2. **Werkzeuge einrichten:** Node.js und VS Code installieren
3. **Das Terminal kennenlernen:** Ordner wechseln, Befehle ausführen

### Kurs „Todo-App“ (`todo-app`)

Empfiehlt „Erste Schritte“. Die App: HTML im Template, JavaScript mit `<script setup>`, kein TypeScript, Tailwind fürs Styling, Icons aus `@lucide/vue`, Aufgaben im `localStorage`. Im Code heißt es durchgehend `tasks`, `addTask`, `checkTask`, `deleteTask` und `clearTasks`; die sichtbaren Texte der App sind deutsch.

**Start**

1. **Was wir bauen:** Die fertige App und der Weg dorthin
2. **Projekt anlegen:** Nuxt-Projekt erzeugen, Entwicklungsserver starten, Blick in die Ordner

**HTML**

3. **Die erste Seite:** `app.vue`, Template, HTML-Grundlagen
4. **Das Gerüst der Todo-App:** Überschrift, Formular, Liste mit festen Beispielaufgaben, Buttons, alles noch ohne Funktion

**CSS**

5. **Tailwind einrichten:** Installation, erste Klassen für Abstände, Farben und Schrift
6. **Die App stylen:** Layout, Karte, Formular und Listeneinträge
7. **Icons mit Lucide:** `@lucide/vue` installieren, Icons für Hinzufügen, Abhaken und Löschen
8. **Feinschliff:** Hover- und Fokus-Zustände, Ansicht auf dem Handy

**JavaScript**

9. **Daten anzeigen:** `<script setup>`, `ref`, Ausgabe mit `{{ }}`, Liste mit `v-for` statt fester Einträge
10. **Aufgaben hinzufügen:** `v-model`, Formular absenden, `addTask`
11. **Aufgaben abhaken:** `checkTask` und zustandsabhängige Klassen
12. **Aufgaben löschen:** `deleteTask`, Filtern der Liste
13. **Zähler und leere Liste:** `computed` und `v-if`
14. **In Komponenten aufteilen:** `TaskItem` mit Props und Events
15. **Speichern im Browser:** `localStorage`, dazu `clearTasks` für den Button „Alle löschen“

**Abschluss**

16. **Geschafft:** Rückblick, Ideen zum Weitermachen und der vollständige Code der fertigen App

Die Lektionen 3 bis 15 haben „Deine Aufgabe“ und eine Musterlösung.

## Tests

- **Zugriffsregeln:** `supabase/tests/rls.sql` prüft zusätzlich, dass ein unveröffentlichter Kurs und die veröffentlichten Lektionen eines unveröffentlichten Kurses unsichtbar sind und dass `course_state` nur für die eigene Zeile les- und schreibbar ist.
- **Logik:** Vitest-Tests für die Zuordnung von Lektionen zu Kursen und die Kursübersicht (Anzahl, erledigt, Prozent).
- **Kursinhalt:** Die Todo-App wird in einem Wegwerf-Ordner exakt nach den Lektionen nachgebaut; jeder Zwischenstand muss ohne Fehler laufen und der Musterlösung entsprechen.
