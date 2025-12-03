<template>
  <div class="min-h-screen flex flex-col bg-[#FAFAFA]">
    <Header />
    <main class="flex-1 pb-16 md:pb-0">
      <slot />
    </main>

    <!-- Mobile bottom navigation -->
    <nav class="fixed inset-x-0 bottom-0 z-40 bg-white border-t border-zinc-200 md:hidden">
      <div class="max-w-7xl mx-auto px-4 flex items-center justify-between h-14 text-[11px] text-zinc-600">
        <NuxtLink
          to="/"
          class="flex flex-col items-center justify-center gap-0.5 flex-1"
        >
          <Home :size="18" />
          <span>Home</span>
        </NuxtLink>
        <NuxtLink
          to="/categories"
          class="flex flex-col items-center justify-center gap-0.5 flex-1"
        >
          <Grid3X3 :size="18" />
          <span>Categories</span>
        </NuxtLink>
        <NuxtLink
          to="/feed"
          class="flex flex-col items-center justify-center gap-0.5 flex-1"
        >
          <Compass :size="18" />
          <span>Feed</span>
        </NuxtLink>
        <NuxtLink
          to="/account"
          class="flex flex-col items-center justify-center gap-0.5 flex-1"
        >
          <User :size="18" />
          <span>Account</span>
        </NuxtLink>
        <NuxtLink
          to="/help"
          class="flex flex-col items-center justify-center gap-0.5 flex-1"
        >
          <HelpCircle :size="18" />
          <span>Help</span>
        </NuxtLink>
      </div>
    </nav>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { Home, Grid3X3, Compass, User, HelpCircle } from 'lucide-vue-next'
</script>
