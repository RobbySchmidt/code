<script setup>
const client = useSupabaseClient()

const pending = ref(false)
const error = ref('')
const notice = ref('')

async function requestReset({ email }) {
  pending.value = true
  error.value = ''
  const { error: authError } = await client.auth.resetPasswordForEmail(email, {
    redirectTo: `${window.location.origin}/passwort-neu`
  })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
  } else {
    notice.value = 'Wenn es zu dieser Adresse ein Konto gibt, haben wir dir eine Mail mit einem Link zum Zurücksetzen geschickt.'
  }
}

useSeoMeta({ title: 'Passwort vergessen' })
</script>

<template>
  <AuthForm
    title="Passwort vergessen"
    submit-label="Link schicken"
    :show-password="false"
    :pending="pending"
    :error="error"
    :notice="notice"
    @submit="requestReset"
  >
    <p><NuxtLink to="/login" class="text-link">Zurück zur Anmeldung</NuxtLink></p>
  </AuthForm>
</template>
