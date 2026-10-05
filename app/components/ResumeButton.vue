<script setup>
const props = defineProps({
  lessons: { type: Array, required: true }
})

const { completedIds } = useProgress()
const { lastLessonId } = useProfile()

const target = computed(() => resumeTarget(props.lessons, completedIds.value, lastLessonId.value))
</script>

<template>
  <NuxtLink v-if="target.state === 'start'" :to="`/kurs/${target.lesson.slug}`" class="btn-primary">
    Kurs starten
  </NuxtLink>
  <NuxtLink v-else-if="target.state === 'continue'" :to="`/kurs/${target.lesson.slug}`" class="btn-primary">
    Kurs weitermachen
  </NuxtLink>
  <p v-else-if="target.state === 'done'" class="text-sm">
    <span class="font-semibold text-ink">Kurs abgeschlossen.</span>
    <NuxtLink :to="`/kurs/${target.lesson.slug}`" class="text-link ml-2">Zur letzten Lektion</NuxtLink>
  </p>
</template>
