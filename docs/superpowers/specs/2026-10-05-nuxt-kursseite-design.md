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
- Profilseite mit Fortschritt, „Kurs weitermachen“ und Passwort ändern
- Der komplette Kursinhalt (16 Lektionen in fünf Blöcken: Start, HTML, CSS, JavaScript, Abschluss)
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
| `/` | Kurze Vorstellung des Kurses, darunter die Lektionsliste, gegliedert nach Blöcken. Eingeloggt: Häkchen je Lektion, Fortschrittsbalken und „Kurs weitermachen“ (siehe „Kurs weitermachen“). |
| `/profil` | Nur eingeloggt erreichbar, sonst Weiterleitung zu `/login`. Zeigt E-Mail-Adresse, Fortschrittsbalken für den ganzen Kurs, Fortschritt je Block („2 von 5“), „Kurs weitermachen“, die nach Blöcken gegliederte Lektionsliste mit Häkchen und Abschlussdatum, ein Formular zum Ändern des Passworts und Logout. |
| `/kurs/[slug]` | Eine Lektion: gerenderter Markdown-Text, Codeblöcke mit Kopier-Button, aufklappbare Musterlösung, „Zurück“/„Weiter“, Button „Lektion abschließen“. Ausgeloggt steht statt des Buttons ein Hinweis mit Link zum Login. |
| `/login` | Anmeldung mit E-Mail und Passwort |
| `/registrieren` | Registrierung mit E-Mail und Passwort |
| `/passwort-vergessen` | Reset-Mail anfordern |
| `/passwort-neu` | Neues Passwort setzen (Ziel des Links aus der Reset-Mail) |
| `/confirm` | Rücksprungseite nach dem Bestätigungslink aus der Registrierungsmail |
| `/impressum`, `/datenschutz` | Platzhalter, im Fuß verlinkt |

Kopfzeile: Kurstitel, dazu Login-Link bzw. Link zum Profil und Logout.

### Kurs weitermachen

Der Button „Kurs weitermachen“ steht auf der Startseite und im Profil und führt zu genau einer Lektion:

1. zur zuletzt geöffneten Lektion, wenn sie veröffentlicht und noch nicht abgeschlossen ist,
2. sonst zur ersten noch nicht abgeschlossenen Lektion in Kursreihenfolge,
3. sind alle Lektionen abgeschlossen, steht statt des Buttons „Kurs abgeschlossen“ mit einem Link zur letzten Lektion.

Wer noch keine Lektion geöffnet hat, sieht den Button als „Kurs starten“; er führt zur ersten Lektion. Die zuletzt geöffnete Lektion wird gespeichert, sobald ein eingeloggter Nutzer eine Lektionsseite öffnet.

Lektionsseite auf großen Bildschirmen: links die Lektionsliste mit Häkchen, rechts der Text in gut lesbarer Spaltenbreite. Auf kleinen Bildschirmen liegt die Liste in einem ausklappbaren Menü.

`redirect` des Supabase-Moduls bleibt `false`: Keine Seite erzwingt einen Login. Lektionen sind ohne Konto lesbar.

### Blöcke

Jede Lektion gehört zu genau einem Block: Start, HTML, CSS, JavaScript oder Abschluss. Die Lektionsliste (Startseite, Seitenleiste, Profil) zeigt die Blöcke als getrennte Gruppen, jede mit Überschrift, Etikett und „x von y erledigt“. Auf der Lektionsseite steht das Etikett des Blocks über dem Titel.

Die Blöcke werden über Gruppierung, Überschriften und Etiketten getrennt, nicht über eigene Farben je Block. Das folgt aus der Stilvorgabe, die genau eine Akzentfarbe erlaubt.

## Gestaltung

Stilreferenz ist das vorgegebene Design-System (Auszug aus brex.com). Übernommen werden Farben, Typografie-Maße, Abstände, Radien und die Regeln; Logo, Markenname und Bildwelt von Brex werden nicht übernommen.

### Token

Die Token kommen als `@theme`-Block in `app/assets/css/main.css`.

| Gruppe | Werte |
|---|---|
| Akzent | Ember `#ff5900` |
| Text | Ink `#000000` (Überschriften, Hervorhebungen), Graphite `#60646c` (Fließtext), Pewter `#6f737b` (Hilfstexte), Steel `#8b8d98` (Platzhalter, Icons) |
| Flächen | Paper `#ffffff` (Seite, Karten), Fog `#f3f3f7` (abgesetzte Bereiche, Eingabefelder) |
| Linien | Mist `#b9bbc6` (1px-Rahmen, Trenner, deaktiviert) |
| Dunkel | Abyss `#000710` (Fuß), Carbon `#15191e` (nur ganz oben auf der Seite) |
| Radien | 12px für Buttons, Eingabefelder und Karten; 6px für Etiketten |
| Abstände | 8px-Raster: 8, 16, 24, 32, 48, 72, 80; Abschnitte 48–80px, Karten-Innenabstand 24–32px |
| Breite | Seite maximal 1200px, Fließtext maximal etwa 640px |

### Schrift

Inter (Google Fonts) in den Gewichten 400, 500 und 600 für alles, auch für Überschriften. Die Display-Schrift Flecha aus der Referenz ist eine kommerzielle Schrift und wird nicht verwendet.

Laufweite negativ wie in der Referenz: −0,01em bis 24px, −0,02em bei 36px, −0,025em bei 48px, −0,03em bei 72px. Die Referenzdateien geben diese Werte teils in px an; maßgeblich sind die em-Werte aus der Beschreibung.

### Regeln

- Ember steht je Bereich nur für die eine Hauptaktion („Kurs weitermachen“, „Lektion abschließen“, Absenden von Formularen), dazu für den Fortschrittsbalken und Häkchen. Keine zweite Akzentfarbe.
- Links im Fließtext sind Ink mit Unterstreichung, nicht Ember.
- Keine Schatten für Karten; Abgrenzung über Paper auf Fog und 1px-Rahmen in Mist.
- Fließtext linksbündig, nicht zentriert.
- Der Fuß ist Abyss mit heller Schrift.
- Codeblöcke in Lektionen stehen auf Fog mit 12px Radius und einem hellen Syntax-Theme.
- Fehlermeldungen sind Ink auf Fog mit Icon; eine eigene Fehlerfarbe gibt es nicht.

## Bausteine

| Baustein | Aufgabe | Hängt ab von |
|---|---|---|
| `useLessons` (Composable) | Lädt die Liste der veröffentlichten Lektionen (ohne Text) und eine einzelne Lektion per Slug | Supabase-Client |
| `useProgress` (Composable) | Lädt die abgeschlossenen Lektionen des eingeloggten Nutzers, schließt eine Lektion ab oder nimmt den Abschluss zurück | Supabase-Client, Nutzer |
| `useProfile` (Composable) | Lädt die zuletzt geöffnete Lektion des eingeloggten Nutzers und speichert sie beim Öffnen einer Lektion | Supabase-Client, Nutzer |
| `utils/progress.js` | Reine Funktionen: Prozentwert, Fortschritt je Block und Ziel von „Kurs weitermachen“ aus Lektionsliste, Menge der abgeschlossenen IDs und zuletzt geöffneter Lektion | nichts |
| `utils/sections.js` | Reihenfolge und Anzeigenamen der Blöcke; gruppiert eine Lektionsliste nach Block | nichts |
| `SectionTag` | Etikett eines Blocks (6px Radius) | `utils/sections.js` |
| `ResumeButton` | „Kurs starten“, „Kurs weitermachen“ oder „Kurs abgeschlossen“ | `useLessons`, `useProgress`, `useProfile`, `utils/progress.js` |
| `PasswordForm` | Passwort ändern im Profil | Supabase-Auth |
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
| `section` | `text`, nicht leer, nur `start`, `html`, `css`, `js`, `abschluss` | Block der Lektion |
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

### `public.profiles`

| Spalte | Typ | Hinweis |
|---|---|---|
| `user_id` | `uuid`, Primärschlüssel, Verweis auf `auth.users`, `on delete cascade` | |
| `last_lesson_id` | `bigint`, darf `null` sein, Verweis auf `lessons`, `on delete set null` | Zuletzt geöffnete Lektion |
| `updated_at` | `timestamptz`, Standard `now()` | |

Die Zeile entsteht beim ersten Öffnen einer Lektion per Upsert; es gibt keinen Trigger bei der Registrierung.

### Zugriffsregeln (RLS)

RLS ist auf allen drei Tabellen aktiv.

- `lessons`: `select` für `anon` und `authenticated`, nur Zeilen mit `published = true`. Keine Regeln für `insert`, `update`, `delete`; Änderungen sind nur über das Dashboard möglich.
- `lesson_progress`: `select`, `insert` und `delete` für `authenticated`, jeweils nur mit `user_id = auth.uid()`. Kein `update`.
- `profiles`: `select`, `insert` und `update` für `authenticated`, jeweils nur mit `user_id = auth.uid()`. Kein `delete`.

## Kursinhalt

### Pflege

- Das Schema liegt als Migration im Repo.
- Die Lektionstexte liegen als SQL-Datei in `supabase/seeds/lessons.sql` und werden genau einmal eingespielt. Danach ist die Datenbank die maßgebliche Quelle; die Datei wird nicht erneut eingespielt, weil das Änderungen aus dem Dashboard überschreiben würde.
- Texte werden danach im Table Editor des Supabase-Dashboards bearbeitet.

### Lektionen

Die Todo-App des Tutorials: HTML im Template, JavaScript mit `<script setup>`, kein TypeScript, Tailwind fürs Styling, Todos im `localStorage`.

Die App entsteht in drei Durchgängen: erst als HTML-Gerüst ohne Funktion, dann gestylt, dann mit JavaScript zum Leben erweckt.

**Start**

1. **Willkommen:** Was wir bauen, was man braucht, wie der Kurs funktioniert
2. **Werkzeuge einrichten:** Node.js und VS Code installieren, das Terminal kennenlernen
3. **Projekt anlegen:** Nuxt-Projekt erzeugen, Entwicklungsserver starten, Blick in die Ordner

**HTML**

4. **Die erste Seite:** `app.vue`, Template, HTML-Grundlagen
5. **Das Gerüst der Todo-App:** Überschrift, Formular, Liste mit festen Beispiel-Todos, Buttons, alles noch ohne Funktion

**CSS**

6. **Tailwind einrichten:** Installation, erste Klassen für Abstände, Farben und Schrift
7. **Die Todo-App stylen:** Layout, Karte, Formular und Listeneinträge
8. **Feinschliff:** Hover- und Fokus-Zustände, Ansicht auf dem Handy

**JavaScript**

9. **Daten anzeigen:** `<script setup>`, `ref`, Ausgabe mit `{{ }}`, Listen mit `v-for` statt fester Einträge
10. **Todos hinzufügen:** `v-model`, Formular absenden, die erste eigene Funktion
11. **Todos abhaken:** Checkbox und zustandsabhängige Klassen
12. **Todos löschen:** Button pro Eintrag, Filtern der Liste
13. **Zähler und leere Liste:** `computed` und `v-if`
14. **In Komponenten aufteilen:** `TodoItem` mit Props und Events
15. **Speichern im Browser:** `localStorage`, dazu der Button „Alle löschen“, der Liste und Speicher leert

**Abschluss**

16. **Geschafft:** Rückblick und Ideen zum Weitermachen

Die Lektionen 3 bis 15 enden mit einer Musterlösung, die den vollständigen Stand der geänderten Dateien zeigt.

## Fehlerfälle

- Unbekannter oder unveröffentlichter Slug: 404-Seite mit Link zur Übersicht
- Supabase nicht erreichbar beim Laden: verständliche Fehlermeldung statt leerer Seite
- Fortschritt lässt sich nicht speichern: Button springt in den vorherigen Zustand zurück und zeigt einen Hinweis
- Anmeldefehler: deutsche Meldungen für falsches Passwort, bereits registrierte E-Mail, noch nicht bestätigtes Konto, zu schwaches Passwort
- Abgelaufener oder ungültiger Reset-Link: Hinweis mit Link zu „Passwort vergessen“

## Tests

- **Zugriffsregeln:** Prüfung direkt gegen die Datenbank, dass Unangemeldete keine unveröffentlichten Lektionen sehen und ein Nutzer fremden Fortschritt weder lesen noch anlegen noch löschen kann
- **Logik:** Vitest-Tests für `utils/progress.js` (Prozentwert, alle Fälle von „Kurs weitermachen“, leere Liste, alles erledigt) und `utils/authErrors.js`
- **Abläufe:** Registrierung, Bestätigung, Login, Lektion abschließen und zurücknehmen, „Kurs weitermachen“ nach erneutem Login, Passwort ändern im Profil, Passwort-Reset und Logout einmal im Browser durchgespielt
- **Kursinhalt:** Die Todo-App wird in einem Wegwerf-Ordner exakt nach den Lektionen nachgebaut; jeder Zwischenstand muss laufen und der Musterlösung entsprechen

## Offene Punkte vor dem Livegang

Diese Punkte gehören nicht zur Umsetzung, müssen aber vor einer Veröffentlichung geklärt sein:

- Eigener SMTP-Dienst, weil der eingebaute Mailversand von Supabase nur wenige Mails pro Stunde erlaubt
- Texte für Impressum und Datenschutzerklärung
- Entscheidung, ob Konten weiterhin nur auf Anfrage im Dashboard gelöscht werden
- Hosting der Kursseite
