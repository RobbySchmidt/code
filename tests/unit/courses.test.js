import { describe, expect, it } from 'vitest'
import { courseOverview, groupLessonsByCourse } from '../../app/utils/courses.js'

const courses = [
  { id: 1, slug: 'erste-schritte' },
  { id: 2, slug: 'todo-app' },
  { id: 3, slug: 'leer' }
]

const lessons = [
  { id: 10, course_id: 1, slug: 'a' },
  { id: 11, course_id: 1, slug: 'b' },
  { id: 20, course_id: 2, slug: 'a' },
  { id: 21, course_id: 2, slug: 'b' },
  { id: 22, course_id: 2, slug: 'c' }
]

describe('groupLessonsByCourse', () => {
  it('ordnet jede Lektion ihrem Kurs zu', () => {
    const groups = groupLessonsByCourse(lessons)
    expect(groups[1].map(l => l.id)).toEqual([10, 11])
    expect(groups[2].map(l => l.id)).toEqual([20, 21, 22])
  })

  it('behält die Reihenfolge der Eingabe je Kurs, auch wenn die Kurse gemischt kommen', () => {
    const mixed = [lessons[2], lessons[0], lessons[3], lessons[1]]
    expect(groupLessonsByCourse(mixed)[2].map(l => l.id)).toEqual([20, 21])
    expect(groupLessonsByCourse(mixed)[1].map(l => l.id)).toEqual([10, 11])
  })

  it('liefert für eine leere Liste ein leeres Objekt', () => {
    expect(groupLessonsByCourse([])).toEqual({})
  })
})

describe('courseOverview', () => {
  it('liefert je Kurs seine Lektionen und den Fortschritt in Kursreihenfolge', () => {
    const overview = courseOverview(courses, lessons, new Set([10, 20, 21]))
    expect(overview.map(o => o.course.id)).toEqual([1, 2, 3])
    expect(overview[0]).toMatchObject({ done: 1, total: 2, percent: 50 })
    expect(overview[1]).toMatchObject({ done: 2, total: 3, percent: 66 })
  })

  it('zählt erledigte Lektionen anderer Kurse nicht mit', () => {
    const overview = courseOverview(courses, lessons, new Set([20, 21, 22]))
    expect(overview[0]).toMatchObject({ done: 0, total: 2, percent: 0 })
    expect(overview[1]).toMatchObject({ done: 3, total: 3, percent: 100 })
  })

  it('zeigt einen Kurs ohne Lektionen mit 0 von 0 und 0 Prozent', () => {
    const overview = courseOverview(courses, lessons, new Set([10]))
    expect(overview[2]).toMatchObject({ lessons: [], done: 0, total: 0, percent: 0 })
  })

  it('lässt Lektionen ohne passenden Kurs weg', () => {
    const orphan = [...lessons, { id: 99, course_id: 42, slug: 'x' }]
    const overview = courseOverview(courses, orphan, new Set([99]))
    expect(overview.flatMap(o => o.lessons.map(l => l.id))).not.toContain(99)
  })

  it('liefert für keine Kurse eine leere Liste', () => {
    expect(courseOverview([], lessons, new Set())).toEqual([])
  })
})
