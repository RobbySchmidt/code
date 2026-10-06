export function useCourseState() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  const state = useAsyncData('course-state', async () => {
    if (!user.value) return []
    const { data, error } = await client.from('course_state').select('course_id, last_lesson_id')
    return error ? [] : data
  }, { watch: [() => user.value?.sub], default: () => [] })

  const rows = state.data
  const lastLessonByCourse = computed(() => Object.fromEntries(rows.value.map(row => [row.course_id, row.last_lesson_id])))

  async function saveLastLesson(courseId, lessonId) {
    const userId = user.value?.sub
    if (!userId) return
    // Erst den laufenden Abruf abwarten, sonst überschreibt sein Ergebnis den neuen Wert.
    await state
    const previous = rows.value
    rows.value = [...previous.filter(row => row.course_id !== courseId), { course_id: courseId, last_lesson_id: lessonId }]
    const { error } = await client
      .from('course_state')
      .upsert({ user_id: userId, course_id: courseId, last_lesson_id: lessonId, updated_at: new Date().toISOString() })
    if (error) rows.value = previous
  }

  return { lastLessonByCourse, saveLastLesson }
}
