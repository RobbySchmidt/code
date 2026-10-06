import { countCompleted, percentComplete } from './progress.js'

export function groupLessonsByCourse(lessons) {
  const groups = {}
  for (const lesson of lessons) {
    (groups[lesson.course_id] ??= []).push(lesson)
  }
  return groups
}

export function courseOverview(courses, lessons, completedIds) {
  const groups = groupLessonsByCourse(lessons)

  return courses.map((course) => {
    const courseLessons = groups[course.id] ?? []
    const { done, total } = countCompleted(courseLessons, completedIds)
    return { course, lessons: courseLessons, done, total, percent: percentComplete(courseLessons, completedIds) }
  })
}
