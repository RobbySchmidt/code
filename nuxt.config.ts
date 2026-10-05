import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: false },
  modules: ['@nuxtjs/supabase'],
  css: ['~/assets/css/main.css'],
  vite: {
    plugins: [tailwindcss()]
  },
  supabase: {
    // Auf true stellen, sobald es eine Login-Seite gibt (Standard: Redirect nach /login)
    redirect: false
  }
})
