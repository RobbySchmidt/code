<script setup>
const user = useSupabaseUser()
const route = useRoute()

// Supabase hängt bei abgelaufenen Links ?error=… an die Adresse oder den Hash.
const failed = ref(false)

watch(user, (current) => {
  if (current) navigateTo('/kurse')
}, { immediate: true })

onMounted(() => {
  // Die Seite läuft nur im Browser; die Sitzung aus dem Link ist beim Mounten schon geklärt.
  // Ohne Nutzer (Link abgelaufen oder in einem anderen Browser geöffnet) gibt es keine Anmeldung.
  if (route.query.error || window.location.hash.includes('error=') || !user.value) failed.value = true
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
