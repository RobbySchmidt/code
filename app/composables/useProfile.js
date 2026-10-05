export function useProfile() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  const profile = useAsyncData('profile', async () => {
    if (!user.value) return null
    const { data, error } = await client.from('profiles').select('last_lesson_id').maybeSingle()
    return error ? null : (data?.last_lesson_id ?? null)
  }, { watch: [() => user.value?.sub], default: () => null })

  const lastLessonId = profile.data

  async function saveLastLesson(lessonId) {
    if (!user.value) return
    // Erst den laufenden Abruf abwarten, sonst überschreibt sein Ergebnis den neuen Wert.
    await profile
    const previous = lastLessonId.value
    lastLessonId.value = lessonId
    const { error } = await client
      .from('profiles')
      .upsert({ user_id: user.value.sub, last_lesson_id: lessonId, updated_at: new Date().toISOString() })
    if (error) lastLessonId.value = previous
  }

  return { lastLessonId, saveLastLesson }
}
