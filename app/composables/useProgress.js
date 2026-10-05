export function useProgress() {
  const client = useSupabaseClient()
  const user = useSupabaseUser()

  const { data: rows } = useAsyncData('progress', async () => {
    if (!user.value) return []
    const { data, error } = await client.from('lesson_progress').select('lesson_id, completed_at')
    return error ? [] : data
  }, { watch: [() => user.value?.sub], default: () => [] })

  const completedIds = computed(() => new Set(rows.value.map(row => row.lesson_id)))
  const completedAt = computed(() => Object.fromEntries(rows.value.map(row => [row.lesson_id, row.completed_at])))

  // Beide Funktionen ändern die Anzeige sofort und nehmen die Änderung zurück, wenn das Speichern scheitert.
  async function complete(lessonId) {
    if (!user.value) return false
    if (completedIds.value.has(lessonId)) return true

    const previous = rows.value
    rows.value = [...previous, { lesson_id: lessonId, completed_at: new Date().toISOString() }]
    const { error } = await client
      .from('lesson_progress')
      .upsert({ user_id: user.value.sub, lesson_id: lessonId }, { onConflict: 'user_id,lesson_id', ignoreDuplicates: true })
    if (error) {
      rows.value = previous
      return false
    }
    return true
  }

  async function uncomplete(lessonId) {
    if (!user.value) return false

    const previous = rows.value
    rows.value = previous.filter(row => row.lesson_id !== lessonId)
    const { error } = await client
      .from('lesson_progress')
      .delete()
      .eq('user_id', user.value.sub)
      .eq('lesson_id', lessonId)
    if (error) {
      rows.value = previous
      return false
    }
    return true
  }

  return { completedIds, completedAt, complete, uncomplete }
}
