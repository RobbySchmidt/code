export function useCourses() {
  const client = useSupabaseClient()

  return useAsyncData('courses', async () => {
    const { data, error } = await client
      .from('courses')
      .select('id, slug, title, summary, position, recommended_course_id')
      .order('position')
    if (error) {
      throw createError({ statusCode: 503, statusMessage: 'Die Kurse konnten nicht geladen werden.' })
    }
    return data
  }, { default: () => [] })
}

// Löst den Kurs aus der Adresse auf. Unbekannte und unveröffentlichte Kurse enden auf der 404-Seite.
export async function useCourseBySlug(slug) {
  const { data: courses, error } = await useCourses()
  if (error.value) {
    throw createError({ statusCode: 503, statusMessage: 'Die Kurse konnten nicht geladen werden.', fatal: true })
  }

  const course = computed(() => courses.value.find(item => item.slug === slug))
  if (!course.value) {
    throw createError({ statusCode: 404, statusMessage: 'Diesen Kurs gibt es nicht.', fatal: true })
  }

  return { course, courses }
}
