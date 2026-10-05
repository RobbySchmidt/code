const LIST_COLUMNS = 'id, slug, title, summary, position, section'

export function useLessons() {
  const client = useSupabaseClient()

  return useAsyncData('lessons', async () => {
    const { data, error } = await client.from('lessons').select(LIST_COLUMNS).order('position')
    if (error) {
      throw createError({ statusCode: 503, statusMessage: 'Die Lektionen konnten nicht geladen werden.' })
    }
    return data
  }, { default: () => [] })
}

export function useLesson(slug) {
  const client = useSupabaseClient()

  return useAsyncData(`lesson-${slug}`, async () => {
    const { data, error } = await client
      .from('lessons')
      .select(`${LIST_COLUMNS}, content, solution`)
      .eq('slug', slug)
      .maybeSingle()
    if (error) {
      throw createError({ statusCode: 503, statusMessage: 'Die Lektion konnte nicht geladen werden.' })
    }
    if (!data) {
      throw createError({ statusCode: 404, statusMessage: 'Diese Lektion gibt es nicht.' })
    }
    return data
  })
}
