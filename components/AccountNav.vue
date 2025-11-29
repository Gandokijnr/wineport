<template>
  <nav class="border-b border-zinc-200 mb-8" aria-label="Account navigation">
    <div class="flex flex-wrap gap-2">
      <NuxtLink
        v-for="item in items"
        :key="item.to"
        :to="item.to"
        class="inline-flex items-center gap-2 rounded-full px-3 py-1.5 text-sm font-medium transition-colors"
        :class="
          route.path === item.to
            ? 'bg-zinc-900 text-white'
            : 'bg-zinc-100 text-zinc-700 hover:bg-zinc-200'
        "
      >
        <component :is="item.icon" :size="16" />
        <span>{{ item.label }}</span>
      </NuxtLink>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { Home, User, MapPin, ShoppingBag, Shield } from 'lucide-vue-next'

const route = useRoute()

const items = [
  { to: '/account', label: 'Dashboard', icon: Home },
  { to: '/account/orders', label: 'Orders', icon: ShoppingBag },
  { to: '/account/profile', label: 'Profile', icon: User },
  { to: '/account/addresses', label: 'Addresses', icon: MapPin },
  { to: '/account/security', label: 'Security', icon: Shield }
]
</script>
