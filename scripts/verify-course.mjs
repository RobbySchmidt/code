// Baut jeden Zwischenstand der Musterlösungen eines Kurses in einem Prüfprojekt
// außerhalb des Repos (<Temp>/kurs-check-<kurs-slug>).
//
// Aufruf: yarn content:verify <kurs-slug> [--from <NN>] [--to <NN>]
//
// Nach jedem Build wird die gebaute App gestartet, / abgerufen (erwartet: 200) und
// wieder beendet. Die npm-Pakete für das Prüfprojekt stehen in kurs.json ("packages").
//
// Das Skript startet nie etwas auf Port 3000 und beendet jeden Prozess, den es
// gestartet hat, auch im Fehlerfall.
import { spawn, spawnSync } from 'node:child_process'
import { cpSync, existsSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs'
import { createServer } from 'node:net'
import { tmpdir } from 'node:os'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import { extractFiles, parseLesson } from './course-content.mjs'

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), '..')
const isWindows = process.platform === 'win32'

// Der nicht-interaktive Aufruf, den wir geprüft haben (create-nuxt 4.0.0). Ohne diese
// drei Angaben bricht das Werkzeug in einem Terminal ohne Tastatur ab; interaktiv
// fragt es Vorlage, Ordner, Paketmanager, Git und (optional) Module.
const SCAFFOLD_ARGS = ['--template', 'minimal', '--packageManager', 'npm', '--no-gitInit']
const READY_MARKER = '.kurs-check-bereit'

const children = new Set()

function killTree(child) {
  if (!child || child.pid === undefined || child.exitCode !== null) return
  try {
    if (isWindows) spawnSync('taskkill', ['/pid', String(child.pid), '/T', '/F'], { stdio: 'ignore' })
    else process.kill(child.pid, 'SIGKILL')
  } catch {
    // Prozess ist schon weg.
  }
}

function killAll() {
  for (const child of children) killTree(child)
  children.clear()
}

process.on('exit', killAll)
for (const signal of ['SIGINT', 'SIGTERM']) {
  process.on(signal, () => {
    killAll()
    process.exit(130)
  })
}

// Führt einen Befehl aus und sammelt die Ausgabe. Gibt { code, output } zurück.
function run(command, args, options = {}) {
  return new Promise((resolve) => {
    // Mit shell: true wird der Befehl als eine Zeichenkette übergeben (die Argumente sind fest im Skript).
    const shell = options.shell ?? false
    const child = spawn(shell ? [command, ...args].join(' ') : command, shell ? [] : args, {
      cwd: options.cwd,
      env: { ...process.env, NUXT_TELEMETRY_DISABLED: '1', ...options.env },
      shell,
      stdio: ['ignore', 'pipe', 'pipe'],
      windowsHide: true
    })
    children.add(child)
    let output = ''
    child.stdout.on('data', chunk => { output += chunk })
    child.stderr.on('data', chunk => { output += chunk })
    child.on('error', (error) => {
      children.delete(child)
      resolve({ code: 1, output: `${output}\n${error.message}` })
    })
    child.on('close', (code) => {
      children.delete(child)
      resolve({ code: code ?? 1, output })
    })
  })
}

const lastLines = (text, count) => text.trimEnd().split(/\r?\n/).slice(-count).join('\n')

function parseArgs(argv) {
  const args = { slug: undefined, from: 1, to: Infinity }
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--from') args.from = Number(argv[++i])
    else if (argv[i] === '--to') args.to = Number(argv[++i])
    else if (!argv[i].startsWith('--') && !args.slug) args.slug = argv[i]
    else throw new Error(`Unbekanntes Argument: ${argv[i]}`)
  }
  if (!args.slug) throw new Error('Aufruf: yarn content:verify <kurs-slug> [--from <NN>] [--to <NN>]')
  if (!/^[a-z0-9-]+$/.test(args.slug)) throw new Error(`Ungültiger Kurs-Adressteil "${args.slug}": erlaubt sind Kleinbuchstaben, Ziffern und Bindestriche.`)
  if (Number.isNaN(args.from) || Number.isNaN(args.to)) throw new Error('--from und --to brauchen eine Zahl.')
  return args
}

function readCourse(slug) {
  const contentDir = join(repoRoot, 'kursinhalt')
  const readMeta = entry => JSON.parse(readFileSync(join(contentDir, entry.name, 'kurs.json'), 'utf8'))
  const folder = readdirSync(contentDir, { withFileTypes: true })
    .filter(entry => entry.isDirectory() && existsSync(join(contentDir, entry.name, 'kurs.json')))
    .find(entry => readMeta(entry).slug === slug)
  if (!folder) throw new Error(`Kein Kurs mit dem Adressteil "${slug}" in kursinhalt/ gefunden.`)
  const dir = join(contentDir, folder.name)
  const packages = readMeta(folder).packages ?? []
  if (!Array.isArray(packages) || packages.some(name => typeof name !== 'string' || !name)) {
    throw new Error(`${folder.name}/kurs.json: packages muss eine Liste von Paketnamen sein.`)
  }
  const lessons = readdirSync(dir)
    .filter(name => name.endsWith('.md') && name !== 'README.md')
    .sort()
    .map((name) => {
      const lesson = parseLesson(name, readFileSync(join(dir, name), 'utf8'))
      return { ...lesson, files: lesson.solution ? extractFiles(lesson.solution) : [] }
    })
  return { lessons, packages }
}

async function ensureProject(projectDir, packages) {
  const marker = join(projectDir, READY_MARKER)
  if (!existsSync(marker)) {
    const parent = dirname(projectDir)
    const name = projectDir.slice(parent.length + 1)
    console.log(`Lege das Prüfprojekt an: ${projectDir}`)
    rmSync(projectDir, { recursive: true, force: true })
    const created = await run('npm', ['create', 'nuxt@latest', '--', name, ...SCAFFOLD_ARGS], { cwd: parent, shell: true })
    if (created.code !== 0) throw new Error(`npm create nuxt ist fehlgeschlagen:\n${lastLines(created.output, 40)}`)
    writeFileSync(marker, 'Gerüst angelegt\n')
  }
  const manifest = JSON.parse(readFileSync(join(projectDir, 'package.json'), 'utf8'))
  const installed = { ...manifest.dependencies, ...manifest.devDependencies }
  const missing = packages.filter(name => !(name in installed))
  if (missing.length) {
    console.log(`Installiere ${missing.join(' ')}`)
    const result = await run('npm', ['install', ...missing], { cwd: projectDir, shell: true })
    if (result.code !== 0) throw new Error(`npm install ist fehlgeschlagen:
${lastLines(result.output, 40)}`)
  }
}

// Merkt sich den Ausgangszustand jeder vom Kurs berührten Datei und spielt ihn zurück.
function resetFiles(projectDir, paths) {
  const originalDir = join(projectDir, '.kurs-original')
  const stateFile = join(originalDir, 'state.json')
  const state = existsSync(stateFile) ? JSON.parse(readFileSync(stateFile, 'utf8')) : {}
  for (const path of paths) {
    if (path in state) continue
    const target = join(projectDir, path)
    state[path] = existsSync(target)
    if (state[path]) {
      mkdirSync(dirname(join(originalDir, 'files', path)), { recursive: true })
      cpSync(target, join(originalDir, 'files', path))
    }
  }
  mkdirSync(originalDir, { recursive: true })
  writeFileSync(stateFile, JSON.stringify(state, null, 2))
  for (const [path, existed] of Object.entries(state)) {
    const target = join(projectDir, path)
    if (existed) {
      mkdirSync(dirname(target), { recursive: true })
      cpSync(join(originalDir, 'files', path), target)
    } else {
      rmSync(target, { force: true })
    }
  }
}

function freePort() {
  return new Promise((resolve, reject) => {
    const server = createServer()
    server.once('error', reject)
    server.listen(0, '127.0.0.1', () => {
      const { port } = server.address()
      server.close(() => resolve(port))
    })
  })
}

async function checkServer(projectDir) {
  const port = await freePort()
  if (port === 3000) throw new Error('Port 3000 ist tabu.')
  const server = spawn(process.execPath, ['.output/server/index.mjs'], {
    cwd: projectDir,
    env: { ...process.env, PORT: String(port), HOST: '127.0.0.1', NITRO_PORT: String(port), NITRO_HOST: '127.0.0.1' },
    stdio: ['ignore', 'pipe', 'pipe'],
    windowsHide: true
  })
  children.add(server)
  let log = ''
  server.stdout.on('data', chunk => { log += chunk })
  server.stderr.on('data', chunk => { log += chunk })
  let exited = false
  server.on('close', () => { exited = true })
  try {
    const deadline = Date.now() + 30000
    let lastError = 'keine Antwort'
    while (Date.now() < deadline && !exited) {
      try {
        const response = await fetch(`http://127.0.0.1:${port}/`)
        if (response.status === 200) return port
        lastError = `HTTP ${response.status}`
      } catch (error) {
        lastError = error.message
      }
      await new Promise(resolve => setTimeout(resolve, 300))
    }
    throw new Error(`Der Server antwortet nicht mit 200 (${lastError}).\n${lastLines(log, 20)}`)
  } finally {
    killTree(server)
    children.delete(server)
  }
}

async function main() {
  const args = parseArgs(process.argv.slice(2))
  const { lessons, packages } = readCourse(args.slug)
  const projectDir = join(tmpdir(), `kurs-check-${args.slug}`)
  await ensureProject(projectDir, packages)

  resetFiles(projectDir, [...new Set(lessons.flatMap(lesson => lesson.files.map(file => file.path)))])

  const report = []
  for (const lesson of lessons) {
    if (lesson.position > args.to) break
    const label = `${String(lesson.position).padStart(2, '0')} ${lesson.slug}`
    for (const file of lesson.files) {
      const target = join(projectDir, file.path)
      mkdirSync(dirname(target), { recursive: true })
      writeFileSync(target, file.code, 'utf8')
    }
    const written = lesson.files.map(file => file.path).join(' ')
    if (!lesson.files.length) {
      report.push(`${label} - keine Dateien`)
      continue
    }
    if (lesson.position < args.from) {
      report.push(`${label} ${written} übersprungen`)
      continue
    }
    const build = await run('npx', ['nuxt', 'build'], { cwd: projectDir, shell: true })
    if (build.code !== 0) {
      console.log(report.join('\n'))
      console.error(`${label} ${written} FEHLER: nuxt build ist fehlgeschlagen. Letzte Zeilen:\n${lastLines(build.output, 40)}`)
      process.exitCode = 1
      return
    }
    try {
      const port = await checkServer(projectDir)
      report.push(`${label} ${written} ok, / antwortet mit 200 (Port ${port})`)
    } catch (error) {
      console.log(report.join('\n'))
      console.error(`${label} ${written} FEHLER: ${error.message}`)
      process.exitCode = 1
      return
    }
  }

  console.log(report.join('\n'))
}

try {
  await main()
} catch (error) {
  console.error(error.message)
  process.exitCode = 1
} finally {
  killAll()
}
