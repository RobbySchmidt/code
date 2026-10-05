<script setup>
const props = defineProps({
  error: { type: Object, default: () => ({}) }
})

const notFound = computed(() => props.error?.statusCode === 404)

useSeoMeta({ title: () => (notFound.value ? 'Seite nicht gefunden' : 'Fehler') })
</script>

<template>
  <div class="flex min-h-screen flex-col bg-paper">
    <main class="mx-auto w-full max-w-[1200px] flex-1 px-4 py-20 sm:px-6">
      <p class="text-sm font-medium text-pewter">{{ notFound ? 'Fehler 404' : 'Fehler' }}</p>
      <h1 class="mt-2 text-4xl font-medium tracking-[-0.02em] text-ink">
        {{ notFound ? 'Diese Seite gibt es nicht.' : 'Da ist etwas schiefgegangen.' }}
      </h1>
      <p class="mt-4 max-w-[640px]">
        {{ notFound
          ? 'Vielleicht hat sich die Adresse geändert, oder die Lektion ist noch nicht veröffentlicht.'
          : 'Die Seite konnte gerade nicht geladen werden. Versuch es in ein paar Minuten noch einmal.' }}
      </p>
      <button type="button" class="btn-primary mt-8" @click="clearError({ redirect: '/' })">
        Zur Übersicht
      </button>
    </main>
  </div>
</template>
