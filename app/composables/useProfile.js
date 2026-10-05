export function useProfile() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  const { data: lastLessonId } = useAsyncData('profile', async () => {
    if (!user.value) return null
    const { data, error } = await client.from('profiles').select('last_lesson_id').maybeSingle()
    return error ? null : (data?.last_lesson_id ?? null)
  }, { watch: [() => user.value?.sub], default: () => null })

  async function saveLastLesson(lessonId) {
    if (!user.value) return
    lastLessonId.value = lessonId
    await client
      .from('profiles')
      .upsert({ user_id: user.value.sub, last_lesson_id: lessonId, updated_at: new Date().toISOString() })
  }

  return { lastLessonId, saveLastLesson }
}
