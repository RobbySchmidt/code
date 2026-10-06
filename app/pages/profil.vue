<script setup>
definePageMeta({ middleware: 'auth' })

const user = useSupabaseUser()
const logout = useLogout()
const { data: courses } = await useCourses()
const { data: lessons } = await useLessons()
const { completedIds } = useProgress()
const { lastLessonByCourse } = useCourseState()

// Begonnen ist ein Kurs, sobald eine seiner Lektionen erledigt oder geöffnet wurde.
const started = computed(() => courseOverview(courses.value, lessons.value, completedIds.value)
  .filter(item => item.done > 0 || lastLessonByCourse.value[item.course.id] != null))

useSeoMeta({ title: 'Profil' })
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <p class="text-sm font-medium text-pewter">Dein Profil</p>
      <h1 class="mt-2 break-words text-4xl font-medium tracking-[-0.02em] text-ink">{{ user?.email }}</h1>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-2xl font-medium text-ink">Deine Kurse</h2>
        <div v-if="started.length === 0" class="mt-8">
          <p class="max-w-[640px]">Du hast noch keinen Kurs begonnen.</p>
          <NuxtLink to="/kurse" class="btn-primary mt-6">Kurse ansehen</NuxtLink>
        </div>
        <ul v-else class="mt-8 grid gap-6 lg:grid-cols-2">
          <li v-for="item in started" :key="item.course.id" class="rounded-xl border border-mist/60 bg-paper p-6">
            <h3 class="text-xl font-medium text-ink">
              <NuxtLink :to="`/kurse/${item.course.slug}`" class="hover:underline">{{ item.course.title }}</NuxtLink>
            </h3>
            <ProgressBar class="mt-4" :percent="item.percent" :label="`${item.done} von ${item.total} Lektionen erledigt`" />
            <div class="mt-6">
              <ResumeButton :course="item.course" :lessons="item.lessons" />
            </div>
          </li>
        </ul>
      </div>
    </section>

    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h2 class="text-2xl font-medium text-ink">Passwort ändern</h2>
      <PasswordForm class="mt-8" />

      <h2 class="mt-16 text-2xl font-medium text-ink">Abmelden</h2>
      <button type="button" class="btn-secondary mt-6" @click="logout">Abmelden</button>
    </section>
  </div>
</template>
