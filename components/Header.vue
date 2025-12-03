<template>
  <header class="sticky top-0 z-50">
    <!-- Top black bar -->
    <div class="hidden sm:block bg-black text-[11px] text-zinc-300">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex items-center justify-between h-8">
        <div class="flex items-center gap-4">
          
          <span class="hidden md:inline text-zinc-500">Premium beverage e‑commerce</span>
        </div>
        <div class="flex items-center gap-4">
          <button type="button" class="hover:text-zinc-100">
            Help Center
          </button>
          <button type="button" class="hover:text-zinc-100">
            Track Order
          </button>
          <button type="button" class="hidden lg:inline hover:text-zinc-100">
            Download App
          </button>
        </div>
      </div>
    </div>

    <!-- Main header -->
    <div class="bg-white border-b border-zinc-200">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between gap-4 h-16 md:h-20">
          <!-- Logo and primary nav -->
          <div class="flex items-center gap-6 shrink-0">
          <NuxtLink to="/" class="flex items-center gap-2">
            <span class="text-2xl font-bold text-[#282828]">Flux</span>
          </NuxtLink>

          <nav class="hidden lg:flex items-center gap-6">
            <NuxtLink
              to="/products"
              class="text-sm font-medium text-zinc-700 hover:text-zinc-900 transition-colors"
            >
              Products
            </NuxtLink>
            <NuxtLink
              to="/categories"
              class="text-sm font-medium text-zinc-700 hover:text-zinc-900 transition-colors"
            >
              Categories
            </NuxtLink>
          </nav>
        </div>

        <!-- Desktop search -->
        <div class="hidden md:flex flex-1">
          <div class="flex w-full max-w-2xl items-stretch rounded-full border border-zinc-300 bg-zinc-50 overflow-hidden">
            <div class="relative flex-1">
              <Search class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" :size="18" />
              <input
                ref="searchInput"
                v-model="searchQuery"
                type="text"
                placeholder="Search products, brands and categories"
                class="w-full pl-10 pr-4 py-2.5 bg-transparent text-sm text-zinc-900 placeholder:text-zinc-400 focus:outline-none"
                @keyup.enter="handleSearch"
              />
            </div>
            <button
              type="button"
              class="px-4 sm:px-5 bg-[#D4AF37] text-[#282828] text-sm font-semibold hover:bg-[#c09b2f] transition-colors flex items-center justify-center gap-2"
              @click="handleSearch"
            >
              <Search :size="16" />
              <span class="hidden sm:inline">Search</span>
            </button>
          </div>
        </div>

        <!-- Actions: search (mobile), help, account, wishlist, cart -->
        <div class="flex items-center gap-2 sm:gap-3">
          <!-- Mobile search toggle -->
          <button
            @click="toggleSearch"
            class="flex md:hidden h-9 w-9 items-center justify-center rounded-full border border-zinc-200 text-zinc-700 hover:bg-zinc-100 hover:text-zinc-900 transition-colors"
            aria-label="Search"
          >
            <Search :size="18" />
          </button>

          <!-- Help dropdown (desktop) -->
          <div class="relative hidden md:block">
            <button
              type="button"
              class="inline-flex items-center gap-1.5 rounded-full border border-zinc-200 px-3 py-1.5 text-xs font-medium text-zinc-700 hover:bg-zinc-50 hover:text-zinc-900 transition-colors"
              @click="toggleHelp"
            >
              <span>Help</span>
              <ChevronDown :size="14" />
            </button>
            <div
              v-if="isHelpOpen"
              class="absolute right-0 mt-2 w-44 rounded-xl bg-white shadow-lg ring-1 ring-black/5 py-2 text-xs text-zinc-700 z-50"
            >
              <NuxtLink to="/help" class="block px-3 py-1.5 hover:bg-zinc-50">Help Center</NuxtLink>
              <NuxtLink to="/support" class="block px-3 py-1.5 hover:bg-zinc-50">Contact support</NuxtLink>
              <NuxtLink to="/orders" class="block px-3 py-1.5 hover:bg-zinc-50">Track order</NuxtLink>
            </div>
          </div>

          <!-- Account dropdown (desktop) -->
          <div class="relative hidden md:block">
            <button
              type="button"
              class="inline-flex items-center gap-1.5 rounded-full border border-zinc-200 px-3 py-1.5 text-xs font-medium text-zinc-700 hover:bg-zinc-50 hover:text-zinc-900 transition-colors"
              @click="toggleAccount"
            >
              <User :size="14" />
              <span>Account</span>
              <ChevronDown :size="14" />
            </button>
            <div
              v-if="isAccountOpen"
              class="absolute right-0 mt-2 w-48 rounded-xl bg-white shadow-lg ring-1 ring-black/5 py-2 text-xs text-zinc-700 z-50"
            >
              <div v-if="loading" class="px-3 py-1.5 text-zinc-400">
                Checking account…
              </div>
              <template v-else-if="user">
                <NuxtLink to="/account" class="block px-3 py-1.5 hover:bg-zinc-50">My account</NuxtLink>
                <NuxtLink to="/orders" class="block px-3 py-1.5 hover:bg-zinc-50">Orders</NuxtLink>
                <button
                  type="button"
                  class="block w-full text-left px-3 py-1.5 hover:bg-zinc-50"
                  @click="handleSignOut"
                >
                  Logout
                </button>
              </template>
              <template v-else>
                <NuxtLink to="/auth/login" class="block px-3 py-1.5 hover:bg-zinc-50">Sign in</NuxtLink>
              </template>
            </div>
          </div>

          <NuxtLink
            to="/wishlist"
            class="relative hidden sm:flex h-9 w-9 items-center justify-center rounded-full border border-zinc-200 text-zinc-700 hover:bg-zinc-100 hover:text-zinc-900 transition-colors"
            aria-label="Wishlist"
          >
            <Heart :size="18" />
            <span
              v-if="wishlistCount > 0"
              class="absolute -top-1.5 -right-1.5 min-w-[1.25rem] h-5 bg-zinc-900 text-white text-[11px] rounded-full flex items-center justify-center px-1"
            >
              {{ wishlistCount }}
            </span>
          </NuxtLink>

          <NuxtLink
            to="/cart"
            class="relative flex h-9 w-9 items-center justify-center rounded-full border border-zinc-200 text-zinc-700 hover:bg-zinc-100 hover:text-zinc-900 transition-colors"
            aria-label="Cart"
          >
            <ShoppingCart :size="18" />
            <span
              v-if="cartCount > 0"
              class="absolute -top-1.5 -right-1.5 min-w-[1.25rem] h-5 bg-zinc-900 text-white text-[11px] rounded-full flex items-center justify-center px-1"
            >
              {{ cartCount }}
            </span>
          </NuxtLink>

          <button
            @click="toggleMenu"
            class="md:hidden flex h-9 w-9 items-center justify-center rounded-full border border-zinc-200 text-zinc-700 hover:bg-zinc-100 hover:text-zinc-900 transition-colors"
            aria-label="Menu"
          >
            <Menu :size="18" />
          </button>
        </div>
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
          <NuxtLink
            to="/wishlist"
            class="block px-4 py-3 text-sm font-medium text-zinc-600 hover:text-zinc-900 hover:bg-zinc-50 rounded-lg transition-colors"
            @click="closeMobileMenu"
          >
            Wishlist
          </NuxtLink>
          <div class="mt-2 border-t border-zinc-100 pt-2">
            <button
              v-if="loading"
              type="button"
              class="block w-full text-left px-4 py-3 text-sm font-medium text-zinc-400"
              disabled
            >
              Checking account…
            </button>
            <template v-else-if="user">
              <NuxtLink
                to="/account"
                class="block px-4 py-3 text-sm font-medium text-zinc-600 hover:text-zinc-900 hover:bg-zinc-50 rounded-lg transition-colors"
                @click="closeMobileMenu"
              >
                My account
              </NuxtLink>
              <NuxtLink
                to="/orders"
                class="block px-4 py-3 text-sm font-medium text-zinc-600 hover:text-zinc-900 hover:bg-zinc-50 rounded-lg transition-colors"
                @click="closeMobileMenu"
              >
                Orders
              </NuxtLink>
              <button
                type="button"
                class="block w-full text-left px-4 py-3 text-sm font-medium text-zinc-600 hover:text-zinc-900 hover:bg-zinc-50 rounded-lg transition-colors"
                @click="handleSignOut"
              >
                Logout
              </button>
            </template>
            <template v-else>
              <NuxtLink
                to="/auth/login"
                class="block px-4 py-3 text-sm font-medium text-zinc-600 hover:text-zinc-900 hover:bg-zinc-50 rounded-lg transition-colors"
                @click="closeMobileMenu"
              >
                Sign in
              </NuxtLink>
            </template>
          </div>
        </nav>
      </div>
    </Transition>
  </header>
</template>

<script setup lang="ts">
import { Search, ShoppingCart, User, Menu, Heart, ChevronDown } from 'lucide-vue-next'

const { cartCount } = useCart()
const { wishlistIds } = useWishlist()
const wishlistCount = computed(() => wishlistIds.value.length)

const { user, loading, checkAuth, signOut } = useAuth()

const isSearchOpen = ref(false)
const isMobileMenuOpen = ref(false)
const isAccountOpen = ref(false)
const isHelpOpen = ref(false)
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

const toggleAccount = () => {
  isAccountOpen.value = !isAccountOpen.value
  if (isAccountOpen.value) {
    isHelpOpen.value = false
  }
}

const toggleHelp = () => {
  isHelpOpen.value = !isHelpOpen.value
  if (isHelpOpen.value) {
    isAccountOpen.value = false
  }
}

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    navigateTo(`/products?search=${encodeURIComponent(searchQuery.value)}`)
    isSearchOpen.value = false
    searchQuery.value = ''
  }
}

const handleSignOut = async () => {
  const { success } = await signOut()
  if (success) {
    isAccountOpen.value = false
    closeMobileMenu()
  }
}

onMounted(() => {
  checkAuth()
})
</script>
