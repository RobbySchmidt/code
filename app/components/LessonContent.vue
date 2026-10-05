<script setup>
defineProps({
  value: { type: String, required: true }
})
</script>

<template>
  <div class="lesson-prose">
    <MDC :value="value" tag="div" />
  </div>
</template>
