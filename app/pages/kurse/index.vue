<script setup>
const user = useSupabaseUser()
const { data: courses, error: coursesError } = await useCourses()
const { data: lessons, error: lessonsError } = await useLessons()
const { completedIds } = useProgress()

const overview = computed(() => courseOverview(courses.value, lessons.value, completedIds.value))
const failed = computed(() => Boolean(coursesError.value || lessonsError.value))

useSeoMeta({
  title: 'Kurse',
  description: 'Alle Kurse im Überblick: Such dir ein Projekt aus und bau es Schritt für Schritt selbst.'
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink sm:text-5xl sm:tracking-[-0.025em]">Kurse</h1>
      <p class="mt-4 max-w-[640px] text-xl">
        Such dir ein Projekt aus und bau es Schritt für Schritt selbst. Jeder Kurs steht für sich.
      </p>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <p v-if="failed" class="notice max-w-[640px] bg-paper" role="alert">
          Die Kurse konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="overview.length === 0">Die ersten Kurse erscheinen bald.</p>
        <ul v-else class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <li v-for="item in overview" :key="item.course.id">
            <CourseCard
              :course="item.course"
              :total="item.total"
              :done="item.done"
              :percent="item.percent"
              :show-progress="Boolean(user) && item.total > 0"
              level="h2"
            />
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>
