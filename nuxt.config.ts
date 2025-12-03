export default defineNuxtConfig({
  devtools: { enabled: false },

  modules: ['@nuxtjs/tailwindcss'],
  ssr: true,
  typescript: {
    strict: true,
    typeCheck: false
  },

  runtimeConfig: {
    public: {
      supabaseUrl: process.env.NUXT_SUPABASE_URL,
      supabaseAnonKey: process.env.NUXT_SUPABASE_ANON_KEY
    }
  },

  app: {
    head: {
      title: 'Flux - Premium Beverage Commerce',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: 'Next-generation beverage e-commerce platform for B2C and B2B customers' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  },

  nitro: {
    compatibilityDate: '2025-12-03'
  },

  vite: {
    server: {
      hmr: {
        host: 'localhost',
        clientPort: 3000
      }
    }
  },

  css: ['~/assets/css/main.css']
})
