<script setup>
const route = useRoute()
const user = useSupabaseUser()

const { course, courses } = await useCourseBySlug(route.params.kurs)
const { data: allLessons, error } = await useLessons()
const { completedIds, completedAt } = useProgress()

const lessons = computed(() => allLessons.value.filter(lesson => lesson.course_id === course.value.id))
const percent = computed(() => percentComplete(lessons.value, completedIds.value))
const counts = computed(() => countCompleted(lessons.value, completedIds.value))

// Der Hinweis auf den empfohlenen Kurs entfällt, sobald dieser vollständig abgeschlossen ist.
const recommended = computed(() => {
  const candidate = courses.value.find(item => item.id === course.value.recommended_course_id)
  if (!candidate) return null
  const candidateLessons = allLessons.value.filter(lesson => lesson.course_id === candidate.id)
  const { done, total } = countCompleted(candidateLessons, completedIds.value)
  return total > 0 && done === total ? null : candidate
})

useSeoMeta({
  title: () => course.value.title,
  description: () => course.value.summary
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <NuxtLink to="/kurse" class="btn-ghost">← Alle Kurse</NuxtLink>
      <h1 class="mt-6 text-4xl font-medium tracking-[-0.02em] text-ink sm:text-5xl sm:tracking-[-0.025em]">
        {{ course.title }}
      </h1>
      <p class="mt-4 max-w-[640px] text-xl">{{ course.summary }}</p>

      <p v-if="recommended" class="notice mt-8 max-w-[640px]">
        Neu hier? Mach zuerst den Kurs
        <NuxtLink :to="`/kurse/${recommended.slug}`" class="text-link">„{{ recommended.title }}“</NuxtLink>.
        Dort richtest du alles ein, was du für diesen Kurs brauchst.
      </p>

      <template v-if="user && lessons.length > 0">
        <ProgressBar class="mt-10 max-w-md" :percent="percent" label="Dein Fortschritt" />
        <p class="mt-2 text-sm">{{ counts.done }} von {{ counts.total }} Lektionen erledigt</p>
      </template>

      <div class="mt-8 flex flex-wrap items-center gap-6">
        <ResumeButton :course="course" :lessons="lessons" />
        <NuxtLink v-if="!user" to="/registrieren" class="btn-ghost">
          Konto erstellen und Fortschritt speichern
        </NuxtLink>
      </div>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-2xl font-medium text-ink">Lektionen</h2>
        <p v-if="error" class="notice mt-8 max-w-[640px] bg-paper" role="alert">
          Die Lektionen konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="lessons.length === 0" class="mt-8">Die Lektionen dieses Kurses erscheinen bald.</p>
        <LessonList
          v-else
          class="mt-8 max-w-3xl"
          :course-slug="course.slug"
          :lessons="lessons"
          :completed-ids="completedIds"
          :completed-at="completedAt"
          :show-counts="Boolean(user)"
          show-summary
        />
      </div>
    </section>
  </div>
</template>
