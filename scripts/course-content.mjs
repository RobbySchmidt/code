// Reine Funktionen für die Kursinhalte: Lektionen lesen, Dateien aus Musterlösungen
// holen und das SQL für den Seed erzeugen. Kein Dateizugriff.

export const SECTIONS = ['start', 'html', 'css', 'js', 'abschluss']
const SOLUTION_MARKER = '<!-- loesung -->'
const FILE_NAME = /^(\d{2})-([a-z0-9-]+)\.md$/
const COMMAND_START = /(^|[\s(])[:@][A-Za-zÄÖÜäöü]/

function fail(fileName, message, line) {
  return new Error(line === undefined ? `${fileName}: ${message}` : `${fileName}:${line}: ${message}`)
}

function readHead(fileName, lines) {
  if (lines[0] !== '---') throw fail(fileName, 'Der Kopf mit title, summary und section fehlt (die Datei muss mit --- beginnen).')
  const end = lines.indexOf('---', 1)
  if (end === -1) throw fail(fileName, 'Der Kopf ist nicht mit --- abgeschlossen.')
  const head = {}
  for (const line of lines.slice(1, end)) {
    const match = line.match(/^([A-Za-z]+):\s*(.*)$/)
    if (match) head[match[1]] = match[2].trim()
  }
  return { head, end }
}

// Verfolgt Codezäune nach CommonMark: Backtick- oder Tilde-Zaun mit mindestens drei
// Zeichen, bis zu drei Leerzeichen Einrückung; geschlossen wird nur von einem Zaun
// derselben Art, der mindestens so lang ist und danach nur Leerraum hat.
const FENCE_OPEN = /^ {0,3}(`{3,}|~{3,})(.*)$/
const FENCE_CLOSE = /^ {0,3}(`{3,}|~{3,})[ 	]*$/

function createFenceTracker() {
  let open = null
  // Liefert 'open' (Eröffnungszeile), 'close' (Schlusszeile), 'inside' oder 'outside'.
  return function step(line) {
    if (open) {
      const match = line.match(FENCE_CLOSE)
      if (match && match[1][0] === open.char && match[1].length >= open.length) {
        const info = open.info
        open = null
        return { state: 'close', info }
      }
      return { state: 'inside', info: open.info }
    }
    const match = line.match(FENCE_OPEN)
    if (match && !(match[1][0] === '`' && match[2].includes('`'))) {
      open = { char: match[1][0], length: match[1].length, info: match[2].trim() }
      return { state: 'open', info: open.info }
    }
    return { state: 'outside', info: '' }
  }
}

// Zeilennummern zählen ab 1 (erste Zeile der Datei = 1).
function checkBody(fileName, lines, firstIndex) {
  const step = createFenceTracker()
  let inCode = false
  lines.forEach((line, i) => {
    const lineNo = firstIndex + i + 1
    // Gilt überall, auch in Codeblöcken: Der SQL-Text steht zwischen $lesson$ ... $lesson$.
    if (line.includes('$lesson')) throw fail(fileName, 'Die Zeichenfolge $lesson$ (auch als $lesson am Zeilenende) darf nirgends vorkommen.', lineNo)
    const { state } = step(line)
    inCode = state === 'open' || state === 'inside'
    if (state !== 'outside') return
    const prose = line.replace(/`[^`]*`/g, '')
    if (prose.includes('{{')) throw fail(fileName, 'Doppelte geschweifte Klammern gehören in Code-Auszeichnung (Backticks).', lineNo)
    if (COMMAND_START.test(prose)) throw fail(fileName, 'Ein Wort mit führendem : oder @ gehört in Code-Auszeichnung (Backticks).', lineNo)
  })
  if (inCode) throw fail(fileName, 'Ein Codeblock ist nicht geschlossen.')
}

export function parseLesson(fileName, text) {
  const nameMatch = fileName.match(FILE_NAME)
  if (!nameMatch) throw fail(fileName, 'Der Dateiname muss NN-adressteil.md heißen (zum Beispiel 03-die-erste-seite.md).')
  const lines = text.replace(/\r\n/g, '\n').split('\n')
  const { head, end } = readHead(fileName, lines)
  for (const key of ['title', 'summary', 'section']) {
    if (!head[key]) throw fail(fileName, `Im Kopf fehlt die Angabe ${key}.`)
  }
  if (!SECTIONS.includes(head.section)) {
    throw fail(fileName, `Unbekannter Block "${head.section}" (erlaubt: ${SECTIONS.join(', ')}).`)
  }

  const bodyLines = lines.slice(end + 1)
  checkBody(fileName, bodyLines, end + 1)

  const marker = bodyLines.findIndex(line => line.trim() === SOLUTION_MARKER)
  const content = (marker === -1 ? bodyLines : bodyLines.slice(0, marker)).join('\n').trim()
  const solution = marker === -1 ? '' : bodyLines.slice(marker + 1).join('\n').trim()
  if (content === '') throw fail(fileName, 'Die Lektion hat keinen Text.')

  return {
    position: Number(nameMatch[1]),
    slug: nameMatch[2],
    title: head.title,
    summary: head.summary,
    section: head.section,
    content,
    solution: solution === '' ? null : solution
  }
}

export function extractFiles(markdown) {
  const lines = markdown.replace(/\r\n/g, '\n').split('\n')
  const step = createFenceTracker()
  const files = []
  let current = null
  for (const line of lines) {
    const { state, info } = step(line)
    if (state === 'open') {
      const match = info.match(/^\S*\s+\[([^\]]+)\]$/)
      if (!match) continue
      const path = match[1].trim()
      if (path.split(/[\\/]/).includes('..') || /^[\\/]/.test(path) || /^[A-Za-z]:/.test(path)) {
        throw new Error(`Ungültiger Dateipfad "${path}": Pfade müssen im Projekt bleiben.`)
      }
      current = { path, code: '' }
    } else if (state === 'inside') {
      if (current) current.code += `${line}\n`
    } else if (state === 'close' && current) {
      files.push(current)
      current = null
    }
  }
  return files
}

const q = value => `'${String(value).replaceAll("'", "''")}'`
const courseId = slug => `(select id from public.courses where slug = ${q(slug)})`

function validate(courses) {
  for (const course of courses) {
    if (typeof course.slug !== 'string' || !/^[a-z0-9-]+$/.test(course.slug)) {
      throw new Error(`Kurs "${course.slug}": Der Adressteil darf nur Kleinbuchstaben, Ziffern und Bindestriche enthalten.`)
    }
    if (!Number.isInteger(course.position)) {
      throw new Error(`Kurs "${course.slug}": Die Position muss eine ganze Zahl sein.`)
    }
  }
  const slugs = new Set()
  const positions = new Set()
  for (const course of courses) {
    if (slugs.has(course.slug)) throw new Error(`Der Adressteil "${course.slug}" kommt bei mehreren Kursen vor.`)
    if (positions.has(course.position)) throw new Error(`Die Position ${course.position} kommt bei mehreren Kursen vor.`)
    slugs.add(course.slug)
    positions.add(course.position)
  }
  for (const course of courses) {
    if (course.recommended && !slugs.has(course.recommended)) {
      throw new Error(`Kurs "${course.slug}": Der empfohlene Kurs "${course.recommended}" existiert nicht.`)
    }
    const lessonSlugs = new Set()
    const lessonPositions = new Set()
    for (const lesson of course.lessons) {
      if (lessonSlugs.has(lesson.slug)) throw new Error(`Kurs "${course.slug}": Der Adressteil "${lesson.slug}" kommt bei mehreren Lektionen vor.`)
      if (lessonPositions.has(lesson.position)) throw new Error(`Kurs "${course.slug}": Die Position ${lesson.position} kommt bei mehreren Lektionen vor.`)
      lessonSlugs.add(lesson.slug)
      lessonPositions.add(lesson.position)
    }
  }
}

export function buildSeedSql(courses) {
  validate(courses)
  const parts = [
    '-- Erzeugt von `yarn content:seed`. Nicht von Hand ändern.\n' +
    '-- Nur einmal einspielen: Das Skript überschreibt Änderungen, die später im Dashboard gemacht wurden.'
  ]

  // (position) ist eindeutig: erst wegschieben, damit vertauschte Positionen den Upsert nicht stören.
  parts.push(`update public.courses set position = position + 1000 where slug in (${courses.map(c => q(c.slug)).join(', ')});`)

  const courseRows = courses.map(c => `  (${q(c.slug)}, ${q(c.title)}, ${q(c.summary)}, ${c.position}, true)`)
  parts.push(
    'insert into public.courses (slug, title, summary, position, published) values\n' +
    `${courseRows.join(',\n')}\n` +
    'on conflict (slug) do update set\n' +
    '  title = excluded.title,\n  summary = excluded.summary,\n  position = excluded.position,\n  published = excluded.published;'
  )

  for (const course of courses) {
    const recommended = course.recommended ? courseId(course.recommended) : 'null'
    parts.push(
      `update public.courses\nset recommended_course_id = ${recommended}\nwhere slug = ${q(course.slug)};`
    )
  }

  for (const course of courses) {
    const keep = course.lessons.map(l => q(l.slug)).join(', ')
    parts.push(
      `delete from public.lessons\nwhere course_id = ${courseId(course.slug)}` +
      (course.lessons.length ? `\n  and slug not in (${keep});` : ';')
    )
  }

  for (const course of courses) {
    if (!course.lessons.length) continue
    const rows = course.lessons.map(l =>
      '  (\n' +
      `    ${courseId(course.slug)},\n` +
      `    ${q(l.slug)}, ${q(l.title)}, ${q(l.summary)}, ${l.position}, ${q(l.section)},\n` +
      `    $lesson$${l.content}$lesson$,\n` +
      `    ${l.solution === null || l.solution === undefined ? 'null' : `$lesson$${l.solution}$lesson$`},\n` +
      '    true\n' +
      '  )'
    )
    parts.push(
      `update public.lessons set position = position + 1000\nwhere course_id = ${courseId(course.slug)};`
    )
    parts.push(
      'insert into public.lessons (course_id, slug, title, summary, position, section, content, solution, published) values\n' +
      `${rows.join(',\n')}\n` +
      'on conflict (course_id, slug) do update set\n' +
      '  title = excluded.title,\n  summary = excluded.summary,\n  position = excluded.position,\n' +
      '  section = excluded.section,\n  content = excluded.content,\n  solution = excluded.solution,\n  published = excluded.published;'
    )
  }

  return `${parts.join('\n\n')}\n`
}
