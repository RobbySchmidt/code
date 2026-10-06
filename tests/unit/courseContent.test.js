import { describe, expect, it } from 'vitest'
import { buildSeedSql, extractFiles, parseLesson } from '../../scripts/course-content.mjs'

const head = '---\ntitle: Die erste Seite\nsummary: Dein erstes HTML.\nsection: html\n---\n'

describe('parseLesson', () => {
  it('liest Position und Adressteil aus dem Dateinamen und die Angaben aus dem Kopf', () => {
    const lesson = parseLesson('03-die-erste-seite.md', `${head}\n## Start\n\nText.\n`)
    expect(lesson).toMatchObject({
      position: 3,
      slug: 'die-erste-seite',
      title: 'Die erste Seite',
      summary: 'Dein erstes HTML.',
      section: 'html',
      solution: null
    })
    expect(lesson.content).toBe('## Start\n\nText.')
  })

  it('trennt die Musterlösung am Marker ab', () => {
    const lesson = parseLesson('03-die-erste-seite.md', `${head}\nText.\n\n<!-- loesung -->\n\n\`\`\`vue [app/app.vue]\n<template />\n\`\`\`\n`)
    expect(lesson.content).toBe('Text.')
    expect(lesson.solution).toBe('```vue [app/app.vue]\n<template />\n```')
  })

  it('kommt mit Windows-Zeilenenden zurecht', () => {
    const lesson = parseLesson('01-start.md', `${head}\nText.\n`.replaceAll('\n', '\r\n'))
    expect(lesson.title).toBe('Die erste Seite')
    expect(lesson.content).toBe('Text.')
  })

  it('lehnt einen falschen Dateinamen ab', () => {
    expect(() => parseLesson('erste-seite.md', `${head}\nText.\n`)).toThrow(/erste-seite\.md/)
  })

  it('lehnt einen fehlenden Kopf und fehlende Angaben ab', () => {
    expect(() => parseLesson('01-a.md', 'Text.')).toThrow(/01-a\.md/)
    expect(() => parseLesson('01-a.md', '---\ntitle: A\nsection: html\n---\n\nText.\n')).toThrow(/summary/)
  })

  it('lehnt einen unbekannten Block ab', () => {
    expect(() => parseLesson('01-a.md', '---\ntitle: A\nsummary: B\nsection: bonus\n---\n\nText.\n')).toThrow(/bonus/)
  })

  it('lehnt eine Lektion ohne Text ab', () => {
    expect(() => parseLesson('01-a.md', `${head}\n\n`)).toThrow(/01-a\.md/)
  })

  it('lehnt doppelte geschweifte Klammern außerhalb von Code ab und nennt die Zeile', () => {
    const text = `${head}\nZeile eins.\n\nMit {{ name }} gibst du etwas aus.\n`
    expect(() => parseLesson('01-a.md', text)).toThrow(/01-a\.md:9/)
  })

  it('erlaubt doppelte geschweifte Klammern in Inline-Code und in Codeblöcken', () => {
    const text = `${head}\nMit \`{{ name }}\` gibst du etwas aus.\n\n\`\`\`vue\n<p>{{ name }}</p>\n\`\`\`\n`
    expect(() => parseLesson('01-a.md', text)).not.toThrow()
  })

  it('lehnt ein Wort mit führendem Doppelpunkt außerhalb von Code ab', () => {
    expect(() => parseLesson('01-a.md', `${head}\nNutze :class für Klassen.\n`)).toThrow(/01-a\.md:7/)
  })

  it('erlaubt Doppelpunkte am Wortende, in Uhrzeiten und in Adressen', () => {
    const text = `${head}\nMerke: Um 10:30 öffnest du http://localhost:3000 im Browser.\n`
    expect(() => parseLesson('01-a.md', text)).not.toThrow()
  })

  it('prüft auch die Musterlösung', () => {
    const text = `${head}\nText.\n\n<!-- loesung -->\n\nHier steht {{ falsch }}.\n`
    expect(() => parseLesson('01-a.md', text)).toThrow(/01-a\.md:11/)
  })

  it('lehnt die Einfassung des SQL-Texts im Inhalt ab', () => {
    expect(() => parseLesson('01-a.md', `${head}\nText mit $lesson$ darin.\n`)).toThrow(/\$lesson\$/)
  })
  it('lehnt $lesson$ auch innerhalb von Codeblöcken ab', () => {
    const text = `${head}\nText.\n\n<!-- loesung -->\n\n\`\`\`js [a.js]\nconst x = '$lesson$'\n\`\`\`\n`
    expect(() => parseLesson('01-a.md', text)).toThrow(/01-a\.md:12.*\$lesson\$/)
  })

  it('lehnt einen Text ab, der auf $lesson endet', () => {
    expect(() => parseLesson('01-a.md', `${head}\nText endet auf $lesson`)).toThrow(/\$lesson/)
  })

  it('erkennt einen Vier-Backtick-Block, der einen Drei-Backtick-Block enthält', () => {
    const block = '````md\n```vue\n<p>{{ x }}</p>\n```\n````\n'
    expect(() => parseLesson('01-a.md', `${head}\n${block}`)).not.toThrow()
    expect(() => parseLesson('01-a.md', `${head}\n${block}\nDanach {{ x }} im Text.\n`)).toThrow(/01-a\.md:13/)
  })

  it('erkennt Tilde-Blöcke', () => {
    expect(() => parseLesson('01-a.md', `${head}\n~~~vue\n<p>{{ x }}</p>\n~~~\n`)).not.toThrow()
  })

  it('erkennt einen um zwei Leerzeichen eingerückten Block in einer Liste', () => {
    const text = `${head}\n- Punkt\n\n  \`\`\`vue\n  <p>{{ x }}</p>\n  \`\`\`\n\nDanach {{ x }}.\n`
    expect(() => parseLesson('01-a.md', text)).toThrow(/01-a\.md:13/)
    expect(() => parseLesson('01-a.md', text.replace('\nDanach {{ x }}.', ''))).not.toThrow()
  })

  it('trennt die Musterlösung auch bei Leerzeichen hinter dem Marker', () => {
    const lesson = parseLesson('01-a.md', `${head}\nText.\n\n<!-- loesung -->   \n\nCode.\n`)
    expect(lesson.content).toBe('Text.')
    expect(lesson.solution).toBe('Code.')
  })
})

describe('extractFiles', () => {
  it('liefert Pfad und Code aller Codeblöcke mit Dateipfad in Reihenfolge', () => {
    const markdown = '```vue [app/app.vue]\n<template />\n```\n\nText\n\n```css [app/assets/css/main.css]\n@import "tailwindcss";\n```\n'
    expect(extractFiles(markdown)).toEqual([
      { path: 'app/app.vue', code: '<template />\n' },
      { path: 'app/assets/css/main.css', code: '@import "tailwindcss";\n' }
    ])
  })

  it('überspringt Codeblöcke ohne Dateipfad', () => {
    expect(extractFiles('```bash\nnpm run dev\n```\n')).toEqual([])
  })

  it('lehnt Pfade ab, die aus dem Projekt herausführen', () => {
    expect(() => extractFiles('```js [../boese.js]\nx\n```\n')).toThrow(/\.\.\/boese\.js/)
    expect(() => extractFiles('```js [/etc/passwd]\nx\n```\n')).toThrow(/\/etc\/passwd/)
  })
  it('liefert den Code eines Vier-Backtick-Blocks mit Drei-Backtick-Zeile unverändert', () => {
    const markdown = '````md [docs/a.md]\n```js\nx\n```\n````\n'
    expect(extractFiles(markdown)).toEqual([{ path: 'docs/a.md', code: '```js\nx\n```\n' }])
  })

  it('erkennt eingerückte Blöcke mit Dateipfad', () => {
    expect(extractFiles('- Punkt\n\n  ```js [a.js]\n  x\n  ```\n')).toEqual([{ path: 'a.js', code: '  x\n' }])
  })
})

describe('buildSeedSql', () => {
  const courses = [
    {
      slug: 'erste-schritte', title: 'Erste Schritte', summary: 'Einstieg.', position: 1,
      lessons: [{ position: 1, slug: 'willkommen', title: "Los geht's", summary: 'Start.', section: 'start', content: 'Hallo.', solution: null }]
    },
    {
      slug: 'todo-app', title: 'Todo-App', summary: 'Die App.', position: 2, recommended: 'erste-schritte',
      lessons: [{ position: 1, slug: 'seite', title: 'Seite', summary: 'HTML.', section: 'html', content: 'Text.', solution: 'Code.' }]
    }
  ]

  it('schreibt Kurse und Lektionen als Upsert und veröffentlicht sie', () => {
    const sql = buildSeedSql(courses)
    expect(sql).toContain("('erste-schritte', 'Erste Schritte', 'Einstieg.', 1, true)")
    expect(sql).toContain('on conflict (slug) do update')
    expect(sql).toContain('on conflict (course_id, slug) do update')
    expect(sql).toContain('$lesson$Hallo.$lesson$')
  })

  it('verdoppelt einfache Anführungszeichen in Titeln', () => {
    expect(buildSeedSql(courses)).toContain("'Los geht''s'")
  })

  it('setzt den empfohlenen Kurs und schreibt null für eine fehlende Musterlösung', () => {
    const sql = buildSeedSql(courses)
    expect(sql).toMatch(/set recommended_course_id = \(select id from public\.courses where slug = 'erste-schritte'\)\s+where slug = 'todo-app'/)
    expect(sql).toMatch(/\$lesson\$Hallo\.\$lesson\$,\s+null,/)
    expect(sql).toContain('$lesson$Code.$lesson$')
  })

  it('entfernt Lektionen eines Kurses, die es im Inhalt nicht mehr gibt', () => {
    expect(buildSeedSql(courses)).toMatch(/delete from public\.lessons\s+where course_id = \(select id from public\.courses where slug = 'todo-app'\)\s+and slug not in \('seite'\)/)
  })

  it('lehnt einen empfohlenen Kurs ab, den es nicht gibt', () => {
    const broken = [{ ...courses[1], recommended: 'gibt-es-nicht' }]
    expect(() => buildSeedSql(broken)).toThrow(/gibt-es-nicht/)
  })

  it('lehnt doppelte Positionen innerhalb eines Kurses ab', () => {
    const lesson = courses[0].lessons[0]
    const broken = [{ ...courses[0], lessons: [lesson, { ...lesson, slug: 'zwei' }] }]
    expect(() => buildSeedSql(broken)).toThrow(/Position 1/)
  })
  it('verschiebt die Positionen der Kurse vor dem Upsert', () => {
    const sql = buildSeedSql(courses)
    const shift = sql.indexOf("update public.courses set position = position + 1000 where slug in ('erste-schritte', 'todo-app');")
    expect(shift).toBeGreaterThan(-1)
    expect(shift).toBeLessThan(sql.indexOf('insert into public.courses'))
  })

  it('lehnt einen ungültigen Adressteil und eine ungültige Position eines Kurses ab', () => {
    expect(() => buildSeedSql([{ ...courses[0], slug: 'zwei worte' }])).toThrow(/zwei worte/)
    expect(() => buildSeedSql([{ ...courses[0], position: 1.5 }])).toThrow(/erste-schritte/)
  })
})
