<script setup>
const user = useSupabaseUser()
const route = useRoute()

// Supabase hängt bei abgelaufenen Links ?error=… an die Adresse.
const failed = ref(Boolean(route.query.error))

watch(user, (current) => {
  if (current) navigateTo('/profil')
}, { immediate: true })

onMounted(() => {
  // Wird der Link in einem anderen Browser geöffnet, entsteht keine Sitzung. Dann nicht endlos warten.
  setTimeout(() => {
    if (!user.value) failed.value = true
  }, 5000)
})

useSeoMeta({ title: 'Konto bestätigen' })
</script>

<template>
  <div class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <template v-if="failed">
      <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Fast geschafft</h1>
      <p class="mt-4">
        Wir konnten dich nicht automatisch anmelden. Wenn du den Link gerade zum ersten Mal geklickt hast,
        ist dein Konto trotzdem bestätigt und du kannst dich anmelden.
      </p>
      <p class="mt-4">Ist der Link abgelaufen, registriere dich noch einmal mit derselben Adresse.</p>
      <NuxtLink to="/login" class="btn-primary mt-8">Zur Anmeldung</NuxtLink>
    </template>
    <template v-else>
      <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Dein Konto wird bestätigt …</h1>
      <p class="mt-4" role="status">Einen Moment, wir melden dich an.</p>
    </template>
  </div>
</template>
