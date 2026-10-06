<script setup>
const props = defineProps({
  course: { type: Object, required: true },
  lessons: { type: Array, required: true }
})

const { completedIds } = useProgress()
const { lastLessonByCourse } = useCourseState()

const target = computed(() => resumeTarget(props.lessons, completedIds.value, lastLessonByCourse.value[props.course.id] ?? null))
</script>

<template>
  <NuxtLink v-if="target.state === 'start'" :to="`/kurse/${course.slug}/${target.lesson.slug}`" class="btn-primary">
    Kurs starten
  </NuxtLink>
  <NuxtLink v-else-if="target.state === 'continue'" :to="`/kurse/${course.slug}/${target.lesson.slug}`" class="btn-primary">
    Kurs weitermachen
  </NuxtLink>
  <p v-else-if="target.state === 'done'" class="text-sm">
    <span class="font-semibold text-ink">Kurs abgeschlossen.</span>
    <NuxtLink :to="`/kurse/${course.slug}/${target.lesson.slug}`" class="text-link ml-2">Zur letzten Lektion</NuxtLink>
  </p>
</template>
