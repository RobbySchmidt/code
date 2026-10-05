import { describe, expect, it } from 'vitest'
import { countCompleted, percentComplete, resumeTarget } from '../../app/utils/progress.js'

const lessons = [
  { id: 10, slug: 'a', section: 'start' },
  { id: 20, slug: 'b', section: 'html' },
  { id: 30, slug: 'c', section: 'js' }
]

describe('countCompleted', () => {
  it('zählt erledigte und alle Lektionen', () => {
    expect(countCompleted(lessons, new Set([10, 30]))).toEqual({ done: 2, total: 3 })
  })

  it('ignoriert erledigte Lektionen, die nicht in der Liste stehen', () => {
    expect(countCompleted(lessons, new Set([10, 999]))).toEqual({ done: 1, total: 3 })
  })
})

describe('percentComplete', () => {
  it('ist 0 bei leerer Liste', () => {
    expect(percentComplete([], new Set([10]))).toBe(0)
  })

  it('rundet ab, damit 100 erst bei allen Lektionen erscheint', () => {
    expect(percentComplete(lessons, new Set([10, 20]))).toBe(66)
  })

  it('ist 100, wenn alles erledigt ist', () => {
    expect(percentComplete(lessons, new Set([10, 20, 30]))).toBe(100)
  })

  it('übersteigt 100 nicht, wenn zurückgezogene Lektionen erledigt waren', () => {
    expect(percentComplete(lessons, new Set([10, 20, 30, 998, 999]))).toBe(100)
  })

  it('rechnet ohne Gleitkomma-Rundungsfehler', () => {
    const hundredLessons = Array.from({ length: 100 }, (_, i) => ({ id: i + 1, slug: `l${i + 1}`, section: 'test' }))
    const completed = new Set(Array.from({ length: 29 }, (_, i) => i + 1))
    expect(percentComplete(hundredLessons, completed)).toBe(29)
  })
})

describe('resumeTarget', () => {
  it('meldet eine leere Lektionsliste', () => {
    expect(resumeTarget([], new Set(), null)).toEqual({ state: 'empty', lesson: null })
  })

  it('startet bei der ersten Lektion, wenn noch nichts passiert ist', () => {
    expect(resumeTarget(lessons, new Set(), null)).toEqual({ state: 'start', lesson: lessons[0] })
  })

  it('führt zur zuletzt geöffneten Lektion, wenn sie offen ist', () => {
    expect(resumeTarget(lessons, new Set([10]), 30)).toEqual({ state: 'continue', lesson: lessons[2] })
  })

  it('führt zur ersten offenen Lektion, wenn die zuletzt geöffnete erledigt ist', () => {
    expect(resumeTarget(lessons, new Set([10, 20]), 20)).toEqual({ state: 'continue', lesson: lessons[2] })
  })

  it('führt zur ersten offenen Lektion, wenn die zuletzt geöffnete nicht mehr existiert', () => {
    expect(resumeTarget(lessons, new Set([10]), 999)).toEqual({ state: 'continue', lesson: lessons[1] })
  })

  it('heißt „weitermachen", sobald etwas erledigt ist, auch ohne zuletzt geöffnete Lektion', () => {
    expect(resumeTarget(lessons, new Set([10]), null)).toEqual({ state: 'continue', lesson: lessons[1] })
  })

  it('heißt „weitermachen", wenn eine Lektion geöffnet, aber nichts erledigt wurde', () => {
    expect(resumeTarget(lessons, new Set(), 10)).toEqual({ state: 'continue', lesson: lessons[0] })
  })

  it('meldet den abgeschlossenen Kurs mit der letzten Lektion', () => {
    expect(resumeTarget(lessons, new Set([10, 20, 30]), 20)).toEqual({ state: 'done', lesson: lessons[2] })
  })
})
