<script setup>
const route = useRoute()
const user = useSupabaseUser()

const { data: lesson, error } = await useLesson(route.params.slug)
if (error.value) {
  throw createError({
    statusCode: error.value.statusCode ?? 500,
    statusMessage: error.value.statusMessage ?? 'Die Lektion konnte nicht geladen werden.',
    fatal: true
  })
}

const { data: lessons } = await useLessons()
const { completedIds } = useProgress()
const { saveLastLesson } = useProfile()

const index = computed(() => lessons.value.findIndex(item => item.id === lesson.value.id))
const previous = computed(() => (index.value > 0 ? lessons.value[index.value - 1] : null))
const next = computed(() => (index.value >= 0 && index.value < lessons.value.length - 1 ? lessons.value[index.value + 1] : null))

// Merkt sich die zuletzt geöffnete Lektion, auch wenn man sich erst auf dieser Seite anmeldet.
watch(() => user.value?.sub, (userId) => {
  if (userId && import.meta.client) saveLastLesson(lesson.value.id)
}, { immediate: true })

useSeoMeta({
  title: () => lesson.value.title,
  description: () => lesson.value.summary
})
</script>

<template>
  <div class="mx-auto grid max-w-[1200px] gap-8 px-4 py-8 sm:px-6 lg:grid-cols-[280px_minmax(0,1fr)] lg:gap-12 lg:py-12">
    <aside>
      <details class="rounded-xl border border-mist/60 lg:hidden">
        <summary class="cursor-pointer px-4 py-3 text-sm font-medium text-ink">Alle Lektionen</summary>
        <div class="border-t border-mist/60 p-4">
          <LessonList :lessons="lessons" :completed-ids="completedIds" :current-slug="lesson.slug" />
        </div>
      </details>
      <nav class="sticky top-8 hidden max-h-[calc(100vh-4rem)] overflow-y-auto lg:block" aria-label="Lektionen">
        <LessonList :lessons="lessons" :completed-ids="completedIds" :current-slug="lesson.slug" />
      </nav>
    </aside>

    <article class="min-w-0">
      <SectionTag :section="lesson.section" />
      <h1 class="mt-3 text-4xl font-medium leading-tight tracking-[-0.02em] text-ink sm:text-5xl sm:tracking-[-0.025em]">
        {{ lesson.title }}
      </h1>
      <p class="mt-4 max-w-[640px] text-xl">{{ lesson.summary }}</p>

      <LessonContent class="mt-10" :value="lesson.content" />
      <LessonSolution v-if="lesson.solution" :value="lesson.solution" />

      <CompleteButton class="mt-12" :lesson-id="lesson.id" />

      <nav class="mt-12 flex max-w-[640px] justify-between gap-4 border-t border-mist/60 pt-6 text-sm" aria-label="Blättern">
        <NuxtLink v-if="previous" :to="`/kurs/${previous.slug}`" class="btn-ghost">← {{ previous.title }}</NuxtLink>
        <span v-else />
        <NuxtLink v-if="next" :to="`/kurs/${next.slug}`" class="btn-ghost text-right">{{ next.title }} →</NuxtLink>
      </nav>
    </article>
  </div>
</template>
