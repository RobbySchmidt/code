<script setup>
defineProps({
  title: { type: String, required: true },
  submitLabel: { type: String, required: true },
  pending: { type: Boolean, default: false },
  error: { type: String, default: '' },
  notice: { type: String, default: '' },
  showEmail: { type: Boolean, default: true },
  showPassword: { type: Boolean, default: true },
  passwordAutocomplete: { type: String, default: 'current-password' }
})

const emit = defineEmits(['submit'])

const email = ref('')
const password = ref('')
</script>

<template>
  <div class="mx-auto w-full max-w-md px-4 py-12 sm:py-20">
    <h1 class="text-4xl font-medium tracking-[-0.02em] text-ink">{{ title }}</h1>

    <p v-if="notice" class="notice mt-8" role="status">{{ notice }}</p>

    <form v-else class="mt-8 space-y-4" @submit.prevent="emit('submit', { email, password })">
      <div v-if="showEmail">
        <label class="field-label" for="auth-email">E-Mail-Adresse</label>
        <input id="auth-email" v-model.trim="email" class="input" type="email" autocomplete="email" required>
      </div>
      <div v-if="showPassword">
        <label class="field-label" for="auth-password">Passwort</label>
        <input
          id="auth-password"
          v-model="password"
          class="input"
          type="password"
          :autocomplete="passwordAutocomplete"
          minlength="8"
          required
        >
        <p v-if="passwordAutocomplete === 'new-password'" class="mt-2 text-xs text-pewter">Mindestens 8 Zeichen.</p>
      </div>

      <p v-if="error" class="notice" role="alert">{{ error }}</p>

      <button type="submit" class="btn-primary w-full" :disabled="pending">
        {{ pending ? 'Einen Moment …' : submitLabel }}
      </button>
    </form>

    <div class="mt-6 space-y-2 text-sm">
      <slot />
    </div>
  </div>
</template>
