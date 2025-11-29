<template>
  <header class="sticky top-0 z-50 bg-black border-b border-black">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <div class="flex items-center gap-8">
          <NuxtLink to="/" class="flex items-center gap-2">
            <span class="text-2xl font-bold text-white">Flux</span>
          </NuxtLink>

          <nav class="hidden md:flex items-center gap-6">
            <NuxtLink
              to="/products"
              class="text-sm font-medium text-zinc-200 hover:text-zinc-500 transition-colors"
            >
              Products
            </NuxtLink>
            <NuxtLink
              to="/categories"
              class="text-sm font-medium text-zinc-200 hover:text-zinc-500 transition-colors"
            >
              Categories
            </NuxtLink>
          </nav>
        </div>

        <div class="flex items-center gap-4">
          <button
            @click="toggleSearch"
            class="p-2 text-zinc-200 hover:text-zinc-500 transition-colors"
            aria-label="Search"
          >
            <Search :size="20" /> 
          </button>

          <NuxtLink
            to="/cart"
            class="relative p-2 text-zinc-200 hover:text-zinc-500 transition-colors"
            aria-label="Cart"
          >
            <ShoppingCart :size="20" />
            <span
              v-if="cartCount > 0"
              class="absolute -top-1 -right-1 w-5 h-5 bg-zinc-900 text-white text-xs rounded-full flex items-center justify-center"
            >
              {{ cartCount }}
            </span>
          </NuxtLink>

          <NuxtLink
            to="/account"
            class="p-2 text-zinc-200 hover:text-zinc-500 transition-colors"
            aria-label="Account"
          >
            <User :size="20" />
          </NuxtLink>

          <button
            @click="toggleMenu"
            class="md:hidden p-2 text-zinc-200 hover:text-zinc-500 transition-colors"
            aria-label="Menu"
          >
            <Menu :size="20" />
          </button>
        </div>
      </div>
    </div>

    <Transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="opacity-0 -translate-y-2"
      enter-to-class="opacity-100 translate-y-0"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="opacity-100 translate-y-0"
      leave-to-class="opacity-0 -translate-y-2"
    >
      <div
        v-if="isSearchOpen"
        class="border-t border-zinc-200 bg-white"
      >
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="relative">
            <Search class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" :size="20" />
            <input
              ref="searchInput"
              v-model="searchQuery"
              type="text"
              placeholder="Search for beverages..."
              class="w-full pl-10 pr-4 py-3 border border-zinc-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-zinc-900 focus:border-transparent"
              @keyup.enter="handleSearch"
            />
          </div>
        </div>
      </div>
    </Transition>

    <Transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="isMobileMenuOpen"
        class="md:hidden border-t border-zinc-200 bg-white"
      >
        <nav class="px-4 py-4 space-y-2">
          <NuxtLink
            to="/products"
            class="block px-4 py-3 text-sm font-medium text-zinc-600 hover:text-zinc-900 hover:bg-zinc-50 rounded-lg transition-colors"
            @click="closeMobileMenu"
          >
            Products
          </NuxtLink>
          <NuxtLink
            to="/categories"
            class="block px-4 py-3 text-sm font-medium text-zinc-600 hover:text-zinc-900 hover:bg-zinc-50 rounded-lg transition-colors"
            @click="closeMobileMenu"
          >
            Categories
          </NuxtLink>
          
        </nav>
      </div>
    </Transition>
  </header>
</template>

<script setup lang="ts">
import { Search, ShoppingCart, User, Menu } from 'lucide-vue-next'

const { cartCount } = useCart()

const isSearchOpen = ref(false)
const isMobileMenuOpen = ref(false)
const searchQuery = ref('')
const searchInput = ref<HTMLInputElement | null>(null)

const toggleSearch = () => {
  isSearchOpen.value = !isSearchOpen.value
  if (isSearchOpen.value) {
    nextTick(() => {
      searchInput.value?.focus()
    })
  }
}

const toggleMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

const closeMobileMenu = () => {
  isMobileMenuOpen.value = false
}

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    navigateTo(`/products?search=${encodeURIComponent(searchQuery.value)}`)
    isSearchOpen.value = false
    searchQuery.value = ''
  }
}
</script>
