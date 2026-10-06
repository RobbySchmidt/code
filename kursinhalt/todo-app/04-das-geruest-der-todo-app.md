---
title: Das Gerüst der Todo-App
summary: Du baust mit HTML alle Teile der App auf: Formular, Liste und Buttons.
section: html
---

In dieser Lektion entsteht das Gerüst der ganzen App. Am Ende ist alles da, was du später brauchst: ein Eingabefeld, eine Liste mit Aufgaben und die Buttons. Hübsch ist es noch nicht, und klicken bringt noch nichts.

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
- **Die Seite lädt neu, wenn du „Erledigt“ klickst:** Die Liste steht versehentlich innerhalb von `<form>`, und dem Button fehlt `type="button"`. Die Liste gehört unter `</form>`.

<!-- loesung -->

```vue [app/app.vue]
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
```
