<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()
const route = useRoute()

const pending = ref(false)
const error = ref('')

// Nur interne Pfade zulassen, damit ?weiter= nicht auf fremde Seiten umleiten kann.
const target = computed(() => {
  const next = route.query.weiter
  return typeof next === 'string' && next.startsWith('/') && !next.startsWith('//') && next[1] !== '\\' ? next : '/kurse'
})

if (user.value) await navigateTo(target.value)

async function login({ email, password }) {
  pending.value = true
  error.value = ''
  const { error: authError } = await client.auth.signInWithPassword({ email, password })
  if (authError) {
    error.value = authErrorMessage(authError)
    pending.value = false
    return
  }
  // Der Nutzer-State des Moduls aktualisiert sich erst verzögert; die Middleware braucht ihn sofort.
  const { data } = await client.auth.getClaims()
  user.value = data?.claims ?? null
  pending.value = false
  await navigateTo(target.value)
}

useSeoMeta({ title: 'Anmelden' })
</script>

<template>
  <AuthForm title="Anmelden" submit-label="Anmelden" :pending="pending" :error="error" @submit="login">
    <p><NuxtLink to="/passwort-vergessen" class="text-link">Passwort vergessen?</NuxtLink></p>
    <p>Noch kein Konto? <NuxtLink to="/registrieren" class="text-link">Konto erstellen</NuxtLink></p>
  </AuthForm>
</template>
