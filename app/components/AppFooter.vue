<template>
  <footer class="bg-abyss">
    <div class="mx-auto flex max-w-[1200px] flex-col gap-4 px-4 py-12 text-sm text-mist sm:flex-row sm:items-center sm:justify-between sm:px-6">
      <p class="font-semibold text-paper">Nuxt für Einsteiger</p>
      <nav class="flex gap-6" aria-label="Rechtliches">
        <NuxtLink to="/impressum" class="hover:text-paper">Impressum</NuxtLink>
        <NuxtLink to="/datenschutz" class="hover:text-paper">Datenschutz</NuxtLink>
      </nav>
    </div>
  </footer>
</template>
