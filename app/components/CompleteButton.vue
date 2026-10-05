<script setup>
const props = defineProps({
  lessonId: { type: Number, required: true }
})

const user = useSupabaseUser()
const route = useRoute()
const { completedIds, complete, uncomplete } = useProgress()

const pending = ref(false)
const failed = ref(false)
const done = computed(() => completedIds.value.has(props.lessonId))

async function toggle() {
  // Schützt vor Doppelklicks, solange die erste Anfrage läuft.
  if (pending.value) return
  pending.value = true
  failed.value = false
  const ok = done.value ? await uncomplete(props.lessonId) : await complete(props.lessonId)
  failed.value = !ok
  pending.value = false
}
</script>

<template>
  <div>
    <template v-if="user">
      <button
        type="button"
        :class="done ? 'btn-secondary' : 'btn-primary'"
        :disabled="pending"
        :aria-pressed="done"
        @click="toggle"
      >
        {{ done ? '✓ Erledigt – zurücknehmen' : 'Lektion abschließen' }}
      </button>
      <p v-if="failed" class="notice mt-4 max-w-[640px]" role="alert">
        Das Speichern hat nicht geklappt. Prüf deine Internetverbindung und versuch es noch einmal.
      </p>
    </template>
    <p v-else class="notice max-w-[640px]">
      <NuxtLink :to="{ path: '/login', query: { weiter: route.fullPath } }" class="text-link">Melde dich an</NuxtLink>,
      um diese Lektion als erledigt zu markieren und deinen Fortschritt zu speichern.
    </p>
  </div>
</template>
