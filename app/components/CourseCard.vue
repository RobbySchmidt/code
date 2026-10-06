<script setup>
defineProps({
  course: { type: Object, required: true },
  total: { type: Number, required: true },
  done: { type: Number, default: 0 },
  percent: { type: Number, default: 0 },
  showProgress: { type: Boolean, default: false },
  level: { type: String, default: 'h3' }
})
</script>

<template>
  <NuxtLink
    :to="`/kurse/${course.slug}`"
    class="flex h-full flex-col rounded-xl border border-mist/60 bg-paper p-6 transition-colors hover:border-ink"
  >
    <component :is="level" class="text-2xl font-medium text-ink">{{ course.title }}</component>
    <p class="mt-2 flex-1">{{ course.summary }}</p>
    <p class="mt-6 text-sm text-pewter">{{ total }} {{ total === 1 ? 'Lektion' : 'Lektionen' }}</p>
    <ProgressBar v-if="showProgress" class="mt-4" :percent="percent" :label="`${done} von ${total} erledigt`" />
  </NuxtLink>
</template>
