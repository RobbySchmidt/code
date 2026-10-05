<script setup>
defineProps({
  percent: { type: Number, required: true },
  label: { type: String, default: 'Fortschritt' }
})
</script>

<template>
  <div>
    <div class="mb-2 flex justify-between text-sm">
      <span class="font-medium text-ink">{{ label }}</span>
      <span>{{ percent }} %</span>
    </div>
    <div
      class="h-2 overflow-hidden rounded-full bg-mist/40"
      role="progressbar"
      :aria-label="label"
      :aria-valuenow="percent"
      aria-valuemin="0"
      aria-valuemax="100"
    >
      <div class="h-full rounded-full bg-ember transition-[width]" :style="{ width: `${percent}%` }" />
    </div>
  </div>
</template>
