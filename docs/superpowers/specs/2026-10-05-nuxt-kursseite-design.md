# Kursseite „Nuxt 4 für Einsteiger“ – Design

Stand: 2026-10-05

## Ziel

Ein freier, deutschsprachiger Schnupperkurs für Menschen ohne Programmiererfahrung. In einem einzigen Tutorial bauen sie lokal auf ihrem eigenen Rechner eine kleine Todo-App mit Nuxt 4 und stylen sie mit Tailwind. Die Kursseite liefert die Lektionen und speichert pro Konto, welche Lektionen abgeschlossen sind.

Erfolg heißt: Jemand ohne Vorkenntnisse kommt von „Node.js installieren“ bis zur fertigen Todo-App, ohne an einem Schritt hängen zu bleiben, und sieht seinen Fortschritt auf jedem Gerät.

## Umfang

Enthalten:

- Lektionen aus Supabase, als Markdown gespeichert und auf der Seite gerendert
- Aufklappbare Musterlösung pro Lektion
- Konto mit E-Mail und Passwort, inklusive Passwort-Reset
- Fortschritt pro Konto über den Button „Lektion abschließen“
- Der komplette Kursinhalt (13 Lektionen)
- Platzhalterseiten für Impressum und Datenschutz

Nicht enthalten:

- Virtueller PC oder Code-Ausführung im Browser (WebContainer)
- Code-Prüffeld auf der Seite, ESLint-Einrichtung als Kursinhalt
- Admin-Bereich zum Bearbeiten der Lektionen (Pflege läuft über das Supabase-Dashboard)
- Quiz, mehrere Kurse, Bezahlung
- Supabase als Thema im Tutorial
- Selbstlöschung des Kontos auf der Seite
- Eigener SMTP-Dienst (nötig vor dem Livegang, siehe „Offene Punkte“)

## Technische Basis

- Nuxt 4 mit `@nuxtjs/supabase` und Tailwind 4 (bereits eingerichtet)
- `@nuxtjs/mdc` zum Rendern von Markdown zur Laufzeit mit Syntax-Highlighting
- Die Kursseite ist in JavaScript mit `<script setup>` geschrieben, ohne TypeScript
- Serverseitiges Rendern; Lektionen werden mit dem öffentlichen Schlüssel geladen
- Supabase-Projekt `code` (Ref `vsoqzbtusinpkeabygxg`), Schemaänderungen als Migrationen in `supabase/migrations/`, eingespielt per `supabase db push` direkt gegen das Remote-Projekt (kein lokaler Docker-Stack)

## Seiten

| Seite | Inhalt |
|---|---|
| `/` | Kurze Vorstellung des Kurses, darunter die Lektionsliste. Eingeloggt: Häkchen je Lektion, Fortschrittsbalken und „Weiterlernen“ zur nächsten offenen Lektion. |
| `/kurs/[slug]` | Eine Lektion: gerenderter Markdown-Text, Codeblöcke mit Kopier-Button, aufklappbare Musterlösung, „Zurück“/„Weiter“, Button „Lektion abschließen“. Ausgeloggt steht statt des Buttons ein Hinweis mit Link zum Login. |
| `/login` | Anmeldung mit E-Mail und Passwort |
| `/registrieren` | Registrierung mit E-Mail und Passwort |
| `/passwort-vergessen` | Reset-Mail anfordern |
| `/passwort-neu` | Neues Passwort setzen (Ziel des Links aus der Reset-Mail) |
| `/confirm` | Rücksprungseite nach dem Bestätigungslink aus der Registrierungsmail |
| `/impressum`, `/datenschutz` | Platzhalter, im Fuß verlinkt |

Kopfzeile: Kurstitel, dazu Login-Link bzw. E-Mail-Adresse und Logout.

Lektionsseite auf großen Bildschirmen: links die Lektionsliste mit Häkchen, rechts der Text in gut lesbarer Spaltenbreite. Auf kleinen Bildschirmen liegt die Liste in einem ausklappbaren Menü.

`redirect` des Supabase-Moduls bleibt `false`: Keine Seite erzwingt einen Login. Lektionen sind ohne Konto lesbar.

## Bausteine

| Baustein | Aufgabe | Hängt ab von |
|---|---|---|
| `useLessons` (Composable) | Lädt die Liste der veröffentlichten Lektionen (ohne Text) und eine einzelne Lektion per Slug | Supabase-Client |
| `useProgress` (Composable) | Lädt die abgeschlossenen Lektionen des eingeloggten Nutzers, schließt eine Lektion ab oder nimmt den Abschluss zurück | Supabase-Client, Nutzer |
| `utils/progress.js` | Reine Funktionen: Prozentwert und nächste offene Lektion aus Lektionsliste und Menge der abgeschlossenen IDs | nichts |
| `LessonList` | Lektionsliste mit Häkchen, für Startseite und Seitenleiste | `useLessons`, `useProgress` |
| `LessonContent` | Rendert Markdown über `<MDC>`, inklusive Codeblock mit Kopier-Button | `@nuxtjs/mdc` |
| `LessonSolution` | Aufklappbarer Bereich mit der Musterlösung; wird nur angezeigt, wenn eine Lösung vorhanden ist | `LessonContent` |
| `CompleteButton` | „Lektion abschließen“ bzw. „Abschluss zurücknehmen“, oder Login-Hinweis | `useProgress` |
| `ProgressBar` | Fortschrittsbalken mit Prozentwert | `utils/progress.js` |
| `AuthForm` | Gemeinsames Formular für Login und Registrierung mit Fehlermeldungen | Supabase-Auth |
| `utils/authErrors.js` | Übersetzt Supabase-Fehlercodes in deutsche Meldungen | nichts |

## Datenmodell

### `public.lessons`

| Spalte | Typ | Hinweis |
|---|---|---|
| `id` | `bigint`, Identity, Primärschlüssel | |
| `slug` | `text`, eindeutig, nicht leer | Adressteil, z. B. `erste-seite` |
| `title` | `text`, nicht leer | |
| `summary` | `text`, nicht leer | Ein Satz für die Lektionsliste |
| `position` | `integer`, eindeutig | Reihenfolge im Kurs |
| `content` | `text`, nicht leer | Markdown |
| `solution` | `text`, darf `null` sein | Markdown |
| `published` | `boolean`, Standard `false` | |
| `created_at` | `timestamptz`, Standard `now()` | |
| `updated_at` | `timestamptz`, Standard `now()` | Wird per Trigger bei Änderungen gesetzt |

### `public.lesson_progress`

| Spalte | Typ | Hinweis |
|---|---|---|
| `user_id` | `uuid`, Verweis auf `auth.users`, `on delete cascade` | |
| `lesson_id` | `bigint`, Verweis auf `lessons`, `on delete cascade` | |
| `completed_at` | `timestamptz`, Standard `now()` | |

Primärschlüssel ist `(user_id, lesson_id)`. Eine Zeile bedeutet „abgeschlossen“; Zurücknehmen löscht die Zeile.

### Zugriffsregeln (RLS)

RLS ist auf beiden Tabellen aktiv.

- `lessons`: `select` für `anon` und `authenticated`, nur Zeilen mit `published = true`. Keine Regeln für `insert`, `update`, `delete`; Änderungen sind nur über das Dashboard möglich.
- `lesson_progress`: `select`, `insert` und `delete` für `authenticated`, jeweils nur mit `user_id = auth.uid()`. Kein `update`.

## Kursinhalt

### Pflege

- Das Schema liegt als Migration im Repo.
- Die Lektionstexte liegen als SQL-Datei in `supabase/seeds/lessons.sql` und werden genau einmal eingespielt. Danach ist die Datenbank die maßgebliche Quelle; die Datei wird nicht erneut eingespielt, weil das Änderungen aus dem Dashboard überschreiben würde.
- Texte werden danach im Table Editor des Supabase-Dashboards bearbeitet.

### Lektionen

Die Todo-App des Tutorials: HTML im Template, JavaScript mit `<script setup>`, kein TypeScript, Tailwind fürs Styling, Todos im `localStorage`.

1. **Willkommen:** Was wir bauen, was man braucht, wie der Kurs funktioniert
2. **Werkzeuge einrichten:** Node.js und VS Code installieren, das Terminal kennenlernen
3. **Projekt anlegen:** Nuxt-Projekt erzeugen, Entwicklungsserver starten, Blick in die Ordner
4. **Die erste Seite:** `app.vue`, Template, HTML-Grundlagen
5. **Tailwind einrichten:** Installation, erste Klassen für Abstände, Farben und Schrift
6. **Daten anzeigen:** `<script setup>`, `ref`, Ausgabe mit `{{ }}`, Listen mit `v-for`
7. **Todos hinzufügen:** Formular, `v-model`, die erste eigene Funktion
8. **Todos abhaken:** Checkbox und zustandsabhängige Klassen
9. **Todos löschen:** Button pro Eintrag, Filtern der Liste
10. **Zähler und leere Liste:** `computed` und `v-if`
11. **In Komponenten aufteilen:** `TodoItem` mit Props und Events
12. **Speichern im Browser:** `localStorage`, dazu der Button „Alle löschen“, der Liste und Speicher leert
13. **Geschafft:** Rückblick und Ideen zum Weitermachen

Ab Lektion 3 endet jede Lektion mit einer Musterlösung, die den vollständigen Stand der geänderten Dateien zeigt.

## Fehlerfälle

- Unbekannter oder unveröffentlichter Slug: 404-Seite mit Link zur Übersicht
- Supabase nicht erreichbar beim Laden: verständliche Fehlermeldung statt leerer Seite
- Fortschritt lässt sich nicht speichern: Button springt in den vorherigen Zustand zurück und zeigt einen Hinweis
- Anmeldefehler: deutsche Meldungen für falsches Passwort, bereits registrierte E-Mail, noch nicht bestätigtes Konto, zu schwaches Passwort
- Abgelaufener oder ungültiger Reset-Link: Hinweis mit Link zu „Passwort vergessen“

## Tests

- **Zugriffsregeln:** Prüfung direkt gegen die Datenbank, dass Unangemeldete keine unveröffentlichten Lektionen sehen und ein Nutzer fremden Fortschritt weder lesen noch anlegen noch löschen kann
- **Logik:** Vitest-Tests für `utils/progress.js` (Prozentwert, nächste offene Lektion, leere Liste, alles erledigt) und `utils/authErrors.js`
- **Abläufe:** Registrierung, Bestätigung, Login, Lektion abschließen und zurücknehmen, Passwort-Reset und Logout einmal im Browser durchgespielt
- **Kursinhalt:** Die Todo-App wird in einem Wegwerf-Ordner exakt nach den Lektionen nachgebaut; jeder Zwischenstand muss laufen und der Musterlösung entsprechen

## Offene Punkte vor dem Livegang

Diese Punkte gehören nicht zur Umsetzung, müssen aber vor einer Veröffentlichung geklärt sein:

- Eigener SMTP-Dienst, weil der eingebaute Mailversand von Supabase nur wenige Mails pro Stunde erlaubt
- Texte für Impressum und Datenschutzerklärung
- Entscheidung, ob Konten weiterhin nur auf Anfrage im Dashboard gelöscht werden
- Hosting der Kursseite
