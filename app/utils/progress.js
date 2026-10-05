export function countCompleted(lessons, completedIds) {
  const done = lessons.filter(lesson => completedIds.has(lesson.id)).length
  return { done, total: lessons.length }
}

export function percentComplete(lessons, completedIds) {
  const { done, total } = countCompleted(lessons, completedIds)
  return total === 0 ? 0 : Math.floor((done / total) * 100)
}

export function resumeTarget(lessons, completedIds, lastLessonId) {
  if (lessons.length === 0) return { state: 'empty', lesson: null }

  const open = lessons.filter(lesson => !completedIds.has(lesson.id))
  if (open.length === 0) return { state: 'done', lesson: lessons[lessons.length - 1] }

  const lastOpened = open.find(lesson => lesson.id === lastLessonId)
  if (lastOpened) return { state: 'continue', lesson: lastOpened }

  const started = lastLessonId != null || open.length < lessons.length
  return { state: started ? 'continue' : 'start', lesson: open[0] }
}
