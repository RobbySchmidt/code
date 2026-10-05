<script setup>
const client = useSupabaseClient()

const password = ref('')
const repeat = ref('')
const pending = ref(false)
const error = ref('')
const saved = ref(false)

async function save() {
  error.value = ''
  saved.value = false
  if (password.value !== repeat.value) {
    error.value = 'Die beiden Passwörter stimmen nicht überein.'
    return
  }
  pending.value = true
  const { error: authError } = await client.auth.updateUser({ password: password.value })
  pending.value = false

  if (authError) {
    error.value = authErrorMessage(authError)
    return
  }
  password.value = ''
  repeat.value = ''
  saved.value = true
}
</script>

<template>
  <form class="max-w-md space-y-4" @submit.prevent="save">
    <div>
      <label class="field-label" for="new-password">Neues Passwort</label>
      <input id="new-password" v-model="password" class="input" type="password" autocomplete="new-password" minlength="8" required>
    </div>
    <div>
      <label class="field-label" for="repeat-password">Neues Passwort wiederholen</label>
      <input id="repeat-password" v-model="repeat" class="input" type="password" autocomplete="new-password" minlength="8" required>
    </div>
    <p v-if="error" class="notice" role="alert">{{ error }}</p>
    <p v-if="saved" class="notice" role="status">Dein Passwort ist geändert.</p>
    <button type="submit" class="btn-secondary" :disabled="pending">
      {{ pending ? 'Einen Moment …' : 'Passwort ändern' }}
    </button>
  </form>
</template>
