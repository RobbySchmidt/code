// Erzeugt supabase/seeds/courses.sql aus allen Kursordnern in kursinhalt/.
import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from 'node:fs'
import { basename, dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { buildSeedSql, parseLesson, seedFileName, selectCourses } from './course-content.mjs'

const root = join(dirname(fileURLToPath(import.meta.url)), '..')
const contentDir = join(root, 'kursinhalt')
const seedDir = join(root, 'supabase', 'seeds')
const argv = process.argv.slice(2)
const prune = argv.includes('--prune')
const wanted = argv.filter(arg => !arg.startsWith('--'))

try {
  const unknownFlag = argv.find(arg => arg.startsWith('--') && arg !== '--prune')
  if (unknownFlag) throw new Error(`Unbekannte Option ${unknownFlag} (erlaubt: --prune).`)
  const courses = []
  const folders = readdirSync(contentDir, { withFileTypes: true })
    .filter(entry => entry.isDirectory() && existsSync(join(contentDir, entry.name, 'kurs.json')))
    .map(entry => entry.name)
    .sort()

  for (const folder of folders) {
    const dir = join(contentDir, folder)
    let meta
    try {
      meta = JSON.parse(readFileSync(join(dir, 'kurs.json'), 'utf8'))
    } catch (error) {
      throw new Error(`${folder}/kurs.json: ${error.message}`)
    }
    for (const key of ['slug', 'title', 'summary', 'position']) {
      if (meta[key] === undefined || meta[key] === '') throw new Error(`${folder}/kurs.json: Die Angabe ${key} fehlt.`)
    }
    const files = readdirSync(dir).filter(name => name.endsWith('.md') && name !== 'README.md').sort()
    const lessons = files.map(name => parseLesson(name, readFileSync(join(dir, name), 'utf8')))
    lessons.sort((a, b) => a.position - b.position)
    courses.push({ ...meta, lessons })
  }

  const selected = selectCourses(courses, wanted)
  const sql = buildSeedSql(selected, { prune, knownSlugs: courses.map(c => c.slug) })
  const outFile = join(seedDir, seedFileName(wanted.length ? selected.map(c => c.slug) : []))
  mkdirSync(dirname(outFile), { recursive: true })
  writeFileSync(outFile, sql, { encoding: 'utf8' })
  for (const course of selected) console.log(`${course.slug}: ${course.lessons.length} Lektionen`)
  console.log(`Geschrieben: supabase/seeds/${basename(outFile)}${prune ? ' (mit --prune)' : ''}`)
} catch (error) {
  console.error(error.message)
  process.exit(1)
}
