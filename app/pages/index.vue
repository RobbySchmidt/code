<script setup>
const user = useSupabaseUser()
const { data: lessons, error } = await useLessons()
const { completedIds } = useProgress()

const percent = computed(() => percentComplete(lessons.value, completedIds.value))

useSeoMeta({
  title: 'Programmieren lernen mit Nuxt',
  description: 'Ein kostenloser Schnupperkurs: Bau Schritt für Schritt deine erste Todo-App mit HTML, CSS und JavaScript.'
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h1 class="max-w-3xl text-5xl font-medium leading-none tracking-[-0.025em] text-ink sm:text-7xl sm:tracking-[-0.03em]">
        Deine erste Web-App. Schritt für Schritt.
      </h1>
      <p class="mt-6 max-w-[640px] text-xl">
        In diesem kostenlosen Kurs baust du auf deinem eigenen Rechner eine Todo-App mit Nuxt.
        Du brauchst keine Vorkenntnisse, nur etwas Neugier.
      </p>
      <div class="mt-8 flex flex-wrap items-center gap-6">
        <ResumeButton :lessons="lessons" />
        <NuxtLink v-if="!user" to="/registrieren" class="btn-ghost">
          Konto erstellen und Fortschritt speichern
        </NuxtLink>
      </div>
      <ProgressBar v-if="user" class="mt-8 max-w-md" :percent="percent" label="Dein Fortschritt" />
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-4xl font-medium tracking-[-0.02em] text-ink">Die Lektionen</h2>
        <p v-if="error" class="notice mt-8 max-w-[640px] bg-paper" role="alert">
          Die Lektionen konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="lessons.length === 0" class="mt-8">Die ersten Lektionen erscheinen bald.</p>
        <LessonList
          v-else
          class="mt-8 max-w-3xl"
          :lessons="lessons"
          :completed-ids="completedIds"
          :show-counts="Boolean(user)"
          show-summary
        />
      </div>
    </section>
  </div>
</template>
