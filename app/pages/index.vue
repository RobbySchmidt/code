<script setup>
const user = useSupabaseUser()
const { data: courses, error: coursesError } = await useCourses()
const { data: lessons, error: lessonsError } = await useLessons()
const { completedIds } = useProgress()

const overview = computed(() => courseOverview(courses.value, lessons.value, completedIds.value))
const failed = computed(() => Boolean(coursesError.value || lessonsError.value))

useSeoMeta({
  title: 'Programmieren lernen mit Nuxt',
  description: 'Kostenlose Schnupperkurse: Bau Schritt für Schritt deine erste eigene Web-App mit HTML, CSS und JavaScript.'
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h1 class="max-w-3xl text-5xl font-medium leading-none tracking-[-0.025em] text-ink sm:text-7xl sm:tracking-[-0.03em]">
        Lern programmieren, indem du etwas baust.
      </h1>
      <p class="mt-6 max-w-[640px] text-xl">
        In kostenlosen Kursen baust du auf deinem eigenen Rechner kleine Web-Apps mit Nuxt.
        Du brauchst keine Vorkenntnisse, nur etwas Neugier.
      </p>
      <div class="mt-8 flex flex-wrap items-center gap-6">
        <NuxtLink to="/kurse" class="btn-primary">Kurse ansehen</NuxtLink>
        <NuxtLink v-if="!user" to="/registrieren" class="btn-ghost">
          Konto erstellen und Fortschritt speichern
        </NuxtLink>
      </div>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-4xl font-medium tracking-[-0.02em] text-ink">Die Kurse</h2>
        <p v-if="failed" class="notice mt-8 max-w-[640px] bg-paper" role="alert">
          Die Kurse konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="overview.length === 0" class="mt-8">Die ersten Kurse erscheinen bald.</p>
        <ul v-else class="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <li v-for="item in overview" :key="item.course.id">
            <CourseCard
              :course="item.course"
              :total="item.total"
              :done="item.done"
              :percent="item.percent"
              :show-progress="Boolean(user) && item.total > 0"
            />
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>
