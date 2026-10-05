<script setup>
defineProps({
  value: { type: String, required: true }
})
</script>

<template>
  <details class="mt-12 max-w-[640px] rounded-xl border border-mist/60">
    <summary class="cursor-pointer px-6 py-4 font-medium text-ink">Musterlösung anzeigen</summary>
    <div class="border-t border-mist/60 px-6 py-2">
      <LessonContent :value="value" />
    </div>
  </details>
</template>
