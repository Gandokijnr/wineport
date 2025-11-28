<template>
  <div class="min-h-screen bg-zinc-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full">
      <div class="text-center mb-8">
        <NuxtLink to="/" class="inline-block">
          <span class="text-3xl font-bold text-zinc-900">LiquidLogistics</span>
        </NuxtLink>
        <h2 class="mt-6 text-3xl font-bold text-zinc-900">Sign in to your account</h2>
        <p class="mt-2 text-sm text-zinc-600">
          Or
          <NuxtLink to="/auth/register" class="font-medium text-zinc-900 hover:text-zinc-700">
            create a new account
          </NuxtLink>
        </p>
      </div>

      <div class="card">
        <form @submit.prevent="handleSignIn" class="space-y-6">
          <div v-if="errorMessage" class="p-4 bg-red-50 border border-red-200 rounded-lg">
            <p class="text-sm text-red-800">{{ errorMessage }}</p>
          </div>

          <div>
            <label for="email" class="block text-sm font-medium text-zinc-900 mb-1">
              Email Address
            </label>
            <input
              id="email"
              v-model="email"
              type="email"
              required
              autocomplete="email"
              class="input"
              placeholder="you@example.com"
            />
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-zinc-900 mb-1">
              Password
            </label>
            <input
              id="password"
              v-model="password"
              type="password"
              required
              autocomplete="current-password"
              class="input"
              placeholder="Enter your password"
            />
          </div>

          <div class="flex items-center justify-between">
            <label class="flex items-center gap-2 cursor-pointer">
              <input
                v-model="rememberMe"
                type="checkbox"
                class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
              />
              <span class="text-sm text-zinc-700">Remember me</span>
            </label>

            <NuxtLink to="/auth/forgot-password" class="text-sm font-medium text-zinc-900 hover:text-zinc-700">
              Forgot password?
            </NuxtLink>
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="btn btn-primary w-full py-3 disabled:opacity-50"
          >
            <span v-if="!loading">Sign In</span>
            <span v-else>Signing in...</span>
          </button>
        </form>
      </div>

      <div v-if="false" class="mt-6 text-center">
        <p class="text-sm text-zinc-600">
          Looking for business solutions?
          <NuxtLink to="/b2b" class="font-medium text-zinc-900 hover:text-zinc-700">
            Learn about B2B
          </NuxtLink>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { signIn } = useAuth()
const router = useRouter()
const route = useRoute()

const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const loading = ref(false)
const errorMessage = ref('')

const handleSignIn = async () => {
  errorMessage.value = ''
  loading.value = true

  const result = await signIn(email.value, password.value)

  if (result.success) {
    const redirect = route.query.redirect as string || '/'
    router.push(redirect)
  } else {
    errorMessage.value = result.error || 'Failed to sign in. Please try again.'
  }

  loading.value = false
}

useHead({
  title: 'Sign In - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Sign in to your LiquidLogistics account'
    }
  ]
})
</script>
