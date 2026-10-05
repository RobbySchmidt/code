import tailwindcss from '@tailwindcss/vite'

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: false },
  modules: ['@nuxtjs/supabase', '@nuxtjs/mdc'],
  css: ['~/assets/css/main.css'],
  app: {
    head: {
      htmlAttrs: { lang: 'de' },
      titleTemplate: '%s · Nuxt für Einsteiger'
    }
  },
  vite: {
    plugins: [tailwindcss()]
  },
  supabase: {
    // Keine Seite erzwingt einen Login; /profil schützt die Middleware "auth".
    redirect: false,
    types: false
  },
  mdc: {
    highlight: {
      theme: 'github-light',
      langs: ['vue', 'html', 'css', 'js', 'json', 'bash']
    }
  }
})
