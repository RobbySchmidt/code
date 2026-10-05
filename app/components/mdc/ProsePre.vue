<script setup>
const props = defineProps({
  code: { type: String, default: '' },
  language: { type: String, default: null },
  filename: { type: String, default: null },
  highlights: { type: Array, default: () => [] },
  meta: { type: String, default: null },
  class: { type: String, default: null }
})

const copied = ref(false)

async function copy() {
  try {
    await navigator.clipboard.writeText(props.code)
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  } catch {
    copied.value = false
  }
}
</script>

<template>
  <div class="code-block">
    <div class="code-block-bar">
      <span>{{ filename || language || 'Code' }}</span>
      <button type="button" class="font-medium text-ink hover:underline" @click="copy">
        {{ copied ? 'Kopiert' : 'Kopieren' }}
      </button>
    </div>
    <pre :class="$props.class"><slot /></pre>
  </div>
</template>
