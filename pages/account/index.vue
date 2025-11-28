<template>
  <div class="min-h-screen bg-zinc-50">
    <div v-if="!user" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="card text-center py-12">
        <Lock :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">Sign in to view your account</h2>
        <p class="text-zinc-600 mb-6">You need to be signed in to access this page</p>
        <NuxtLink to="/auth/login?redirect=/account" class="btn btn-primary">
          Sign In
        </NuxtLink>
      </div>
    </div>

    <div v-else class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <h1 class="text-4xl font-bold text-zinc-900 mb-8">My Account</h1>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <NuxtLink to="/account/orders" class="card hover:shadow-lg transition-shadow cursor-pointer">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 bg-zinc-900 rounded-lg flex items-center justify-center">
              <Package class="text-white" :size="24" />
            </div>
            <div>
              <h3 class="text-lg font-semibold text-zinc-900">Orders</h3>
              <p class="text-sm text-zinc-600">View order history</p>
            </div>
          </div>
        </NuxtLink>

        <NuxtLink to="/account/profile" class="card hover:shadow-lg transition-shadow cursor-pointer">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 bg-zinc-900 rounded-lg flex items-center justify-center">
              <User class="text-white" :size="24" />
            </div>
            <div>
              <h3 class="text-lg font-semibold text-zinc-900">Profile</h3>
              <p class="text-sm text-zinc-600">Manage your details</p>
            </div>
          </div>
        </NuxtLink>

        <NuxtLink to="/account/addresses" class="card hover:shadow-lg transition-shadow cursor-pointer">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 bg-zinc-900 rounded-lg flex items-center justify-center">
              <MapPin class="text-white" :size="24" />
            </div>
            <div>
              <h3 class="text-lg font-semibold text-zinc-900">Addresses</h3>
              <p class="text-sm text-zinc-600">Manage saved addresses</p>
            </div>
          </div>
        </NuxtLink>
      </div>

      <div class="mt-8">
        <button
          @click="handleSignOut"
          class="btn btn-outline text-red-600 hover:bg-red-50 border-red-300"
        >
          Sign Out
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Package, User, MapPin, Lock } from 'lucide-vue-next'

const { user, signOut, checkAuth } = useAuth()
const router = useRouter()

const handleSignOut = async () => {
  const result = await signOut()
  if (result.success) {
    router.push('/')
  }
}

onMounted(() => {
  checkAuth()
})

useHead({
  title: 'My Account - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Manage your LiquidLogistics account'
    }
  ]
})
</script>
