<script setup>
definePageMeta({ middleware: 'auth' })

const user = useSupabaseUser()
const logout = useLogout()
const { data: lessons } = await useLessons()
const { completedIds } = useProgress()

const percent = computed(() => percentComplete(lessons.value, completedIds.value))
const counts = computed(() => countCompleted(lessons.value, completedIds.value))

useSeoMeta({ title: 'Profil' })
</script>

<template>
  <div>
    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <p class="text-sm font-medium text-pewter">Dein Profil</p>
      <h1 class="mt-2 break-words text-4xl font-medium tracking-[-0.02em] text-ink">{{ user?.email }}</h1>

      <ProgressBar class="mt-10 max-w-md" :percent="percent" label="Dein Fortschritt" />
      <p class="mt-2 text-sm">{{ counts.done }} von {{ counts.total }} Lektionen erledigt</p>

      <div class="mt-8 flex flex-wrap items-center gap-6">
        <ResumeButton :lessons="lessons" />
        <NuxtLink to="/lektionen" class="btn-ghost">Alle Lektionen ansehen</NuxtLink>
      </div>
    </section>

    <section class="bg-fog">
      <div class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
        <h2 class="text-2xl font-medium text-ink">Passwort ändern</h2>
        <div class="mt-8 max-w-md rounded-xl border border-mist/60 bg-paper p-6">
          <PasswordForm />
        </div>
      </div>
    </section>

    <section class="mx-auto max-w-[1200px] px-4 py-12 sm:px-6 sm:py-20">
      <h2 class="text-2xl font-medium text-ink">Abmelden</h2>
      <button type="button" class="btn-secondary mt-6" @click="logout">Abmelden</button>
    </section>
  </div>
</template>
