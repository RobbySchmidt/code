<script setup>
defineProps({
  section: { type: String, required: true }
})
</script>

<template>
  <span class="inline-block rounded-md border border-mist px-2 py-0.5 text-xs font-medium text-ink">
    {{ sectionLabel(section) }}
  </span>
</template>
