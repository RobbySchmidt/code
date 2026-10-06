<script setup>
const props = defineProps({
  courseSlug: { type: String, required: true },
  lessons: { type: Array, required: true },
  completedIds: { type: Set, default: () => new Set() },
  completedAt: { type: Object, default: () => ({}) },
  currentSlug: { type: String, default: null },
  showSummary: { type: Boolean, default: false },
  showCounts: { type: Boolean, default: false }
})

const groups = computed(() => groupBySection(props.lessons))

// Feste Zeitzone, damit Server und Browser dasselbe Datum rendern.
function formatDate(iso) {
  return new Date(iso).toLocaleDateString('de-DE', { timeZone: 'Europe/Berlin' })
}
</script>

<template>
  <div class="space-y-8">
    <section v-for="group in groups" :key="group.key" :aria-label="group.label">
      <div class="mb-3 flex items-center justify-between gap-4">
        <SectionTag :section="group.key" />
        <span v-if="showCounts" class="text-xs text-pewter">
          {{ countCompleted(group.lessons, completedIds).done }} von {{ group.lessons.length }} erledigt
        </span>
      </div>
      <ol class="overflow-hidden rounded-xl border border-mist/60 bg-paper">
        <li v-for="lesson in group.lessons" :key="lesson.id" class="border-b border-mist/60 last:border-b-0">
          <NuxtLink
            :to="`/kurse/${courseSlug}/${lesson.slug}`"
            class="flex items-start gap-3 px-4 py-3 hover:bg-fog"
            :class="{ 'bg-fog': lesson.slug === currentSlug }"
            :aria-current="lesson.slug === currentSlug ? 'page' : undefined"
          >
            <span
              class="mt-0.5 flex size-5 shrink-0 items-center justify-center rounded-full border text-[10px] font-semibold"
              :class="completedIds.has(lesson.id) ? 'border-ember bg-ember text-paper' : 'border-mist text-pewter'"
            >
              <template v-if="completedIds.has(lesson.id)">
                <span aria-hidden="true">✓</span>
                <span class="sr-only">Erledigt:</span>
              </template>
              <span v-else aria-hidden="true">{{ lesson.position }}</span>
            </span>
            <span class="min-w-0 flex-1">
              <span class="block text-sm font-medium text-ink">{{ lesson.title }}</span>
              <span v-if="showSummary" class="mt-0.5 block text-sm">{{ lesson.summary }}</span>
            </span>
            <span v-if="completedAt[lesson.id]" class="shrink-0 text-xs text-pewter">
              {{ formatDate(completedAt[lesson.id]) }}
            </span>
          </NuxtLink>
        </li>
      </ol>
    </section>
  </div>
</template>
