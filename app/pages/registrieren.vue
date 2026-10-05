<script setup>
const client = useSupabaseClient()

const pending = ref(false)
const error = ref('')
const notice = ref('')

async function register({ email, password }) {
  pending.value = true
  error.value = ''
  const { data, error: authError } = await client.auth.signUp({
    email,
    password,
    options: { emailRedirectTo: `${window.location.origin}/confirm` }
  })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
  } else if (isExistingAccountSignup(data)) {
    error.value = EXISTING_ACCOUNT_MESSAGE
  } else {
    notice.value = 'Fast geschafft: Wir haben dir eine Mail geschickt. Klick auf den Link darin, um dein Konto zu bestätigen.'
  }
}

useSeoMeta({ title: 'Konto erstellen' })
</script>

<template>
  <AuthForm
    title="Konto erstellen"
    submit-label="Konto erstellen"
    password-autocomplete="new-password"
    :pending="pending"
    :error="error"
    :notice="notice"
    @submit="register"
  >
    <p>Schon ein Konto? <NuxtLink to="/login" class="text-link">Anmelden</NuxtLink></p>
  </AuthForm>
</template>
