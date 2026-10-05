<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()
const route = useRoute()

const pending = ref(false)
const error = ref('')
// Ohne Sitzung aus dem Reset-Link lässt sich kein Passwort setzen.
const invalidLink = ref(false)

onMounted(() => {
  // Die Seite läuft nur im Browser; die Sitzung aus dem Link ist beim Mounten schon geklärt.
  if (route.query.error || window.location.hash.includes('error=') || !user.value) invalidLink.value = true
})

async function savePassword({ password }) {
  pending.value = true
  error.value = ''
  const { error: authError } = await client.auth.updateUser({ password })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
    return
  }
  await navigateTo('/profil')
}

useSeoMeta({ title: 'Neues Passwort' })
</script>

<template>
  <div v-if="invalidLink && !user" class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Der Link funktioniert nicht mehr</h1>
    <p class="mt-4">
      Er ist abgelaufen, wurde schon benutzt oder in einem anderen Browser geöffnet als dem,
      in dem du ihn angefordert hast.
    </p>
    <NuxtLink to="/passwort-vergessen" class="btn-primary mt-8">Neuen Link anfordern</NuxtLink>
  </div>
  <AuthForm
    v-else-if="user"
    title="Neues Passwort"
    submit-label="Passwort speichern"
    password-autocomplete="new-password"
    :show-email="false"
    :pending="pending"
    :error="error"
    @submit="savePassword"
  />
  <div v-else class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">Neues Passwort</h1>
    <p class="mt-4" role="status">Einen Moment, wir prüfen deinen Link …</p>
  </div>
</template>
