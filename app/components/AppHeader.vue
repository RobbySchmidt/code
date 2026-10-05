<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()

async function logout() {
  await client.auth.signOut()
  user.value = null
  await navigateTo('/')
}
</script>

<template>
  <header class="border-b border-mist/60">
    <div class="mx-auto flex max-w-[1200px] items-center justify-between gap-4 px-4 py-4 sm:px-6">
      <NuxtLink to="/" class="text-xl font-medium tracking-[-0.02em] text-ink">
        Nuxt für Einsteiger
      </NuxtLink>
      <nav class="flex items-center gap-4 text-sm font-medium text-ink" aria-label="Konto">
        <template v-if="user">
          <NuxtLink to="/profil" class="hover:underline">Profil</NuxtLink>
          <button type="button" class="hover:underline" @click="logout">Abmelden</button>
        </template>
        <template v-else>
          <NuxtLink to="/login" class="hover:underline">Anmelden</NuxtLink>
          <NuxtLink to="/registrieren" class="btn-primary">Konto erstellen</NuxtLink>
        </template>
      </nav>
    </div>
  </header>
</template>
