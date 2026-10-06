<script setup>
const user = useSupabaseUser()
const { data: lessons, error } = await useLessons()
const { completedIds, completedAt } = useProgress()

const percent = computed(() => percentComplete(lessons.value, completedIds.value))
const counts = computed(() => countCompleted(lessons.value, completedIds.value))

useSeoMeta({
  title: 'Lektionen',
  description: 'Alle Lektionen des Kurses im Überblick, gegliedert nach Start, HTML, CSS und JavaScript.'
})
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink sm:text-5xl sm:tracking-[-0.025em]">Lektionen</h1>
      <p class="mt-4 max-w-[640px] text-xl">
        Der Kurs führt dich in fünf Blöcken von der Einrichtung bis zur fertigen Todo-App.
      </p>

      <template v-if="user">
        <ProgressBar class="mt-10 max-w-md" :percent="percent" label="Dein Fortschritt" />
        <p class="mt-2 text-sm">{{ counts.done }} von {{ counts.total }} Lektionen erledigt</p>
      </template>

      <div class="mt-8 flex flex-wrap items-center gap-6">
        <ResumeButton :lessons="lessons" />
        <NuxtLink v-if="!user" to="/registrieren" class="btn-ghost">
          Konto erstellen und Fortschritt speichern
        </NuxtLink>
      </div>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <p v-if="error" class="notice max-w-[640px] bg-paper" role="alert">
          Die Lektionen konnten gerade nicht geladen werden. Lade die Seite bitte neu.
        </p>
        <p v-else-if="lessons.length === 0">Die ersten Lektionen erscheinen bald.</p>
        <LessonList
          v-else
          class="max-w-3xl"
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
