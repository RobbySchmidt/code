<script setup>
const user = useSupabaseUser()
const logout = useLogout()
</script>

<template>
  <header class="sticky top-0 z-20 border-b border-mist/60 bg-paper">
    <div class="mx-auto flex max-w-[1200px] flex-wrap items-center justify-between gap-x-4 gap-y-3 px-4 py-4 sm:px-6">
      <NuxtLink to="/" class="text-xl font-medium tracking-[-0.02em] text-ink">
        Nuxt für Einsteiger
      </NuxtLink>
      <nav class="flex items-center gap-4 text-sm font-medium text-ink" aria-label="Hauptmenü">
        <NuxtLink to="/kurse" class="transition-colors hover:text-ember" active-class="text-ember">Kurse</NuxtLink>
        <template v-if="user">
          <NuxtLink to="/profil" class="transition-colors hover:text-ember" active-class="text-ember">Profil</NuxtLink>
          <button type="button" class="btn-primary" @click="logout">Abmelden</button>
        </template>
        <template v-else>
          <NuxtLink to="/login" class="transition-colors hover:text-ember" active-class="text-ember">Anmelden</NuxtLink>
          <NuxtLink to="/registrieren" class="btn-primary">Konto erstellen</NuxtLink>
        </template>
      </nav>
    </div>
  </header>
</template>
