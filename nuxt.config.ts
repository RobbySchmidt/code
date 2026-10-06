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
    },
    pageTransition: { name: 'page', mode: 'out-in' }
  },
  vite: {
    plugins: [tailwindcss()]
  },
  // Diese Seiten brauchen die Sitzung aus dem Link und werden deshalb nur im Browser gerendert.
  routeRules: {
    '/confirm': { ssr: false },
    '/passwort-neu': { ssr: false }
  },
  supabase: {
    // Keine Seite erzwingt einen Login; /profil schützt die Middleware "auth".
    redirect: false,
    types: false,
    // Die Anmeldung bleibt 30 Tage bestehen.
    cookieOptions: { maxAge: 60 * 60 * 24 * 30, sameSite: 'lax', secure: true }
  },
  mdc: {
    highlight: {
      theme: 'github-light',
      langs: ['vue', 'html', 'css', 'js', 'json', 'bash']
    }
  }
})
