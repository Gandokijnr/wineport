<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-6">
        <NuxtLink to="/account" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
          &larr; Back to Account
        </NuxtLink>
        <h1 class="text-3xl font-bold text-zinc-900">Security</h1>
      </div>

      <AccountNav />

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <section class="card">
          <h2 class="text-lg font-semibold text-zinc-900 mb-2">Password</h2>
          <p class="text-sm text-zinc-600 mb-4">
            Send a password reset email to your account address.
          </p>
          <button class="btn btn-primary" @click="sendReset" :disabled="sendingReset">
            {{ sendingReset ? 'Sending…' : 'Send reset link' }}
          </button>
        </section>

        <section class="card">
          <h2 class="text-lg font-semibold text-zinc-900 mb-2">Sign out</h2>
          <p class="text-sm text-zinc-600 mb-4">
            Sign out of this device.
          </p>
          <button class="btn btn-secondary" @click="handleSignOut">
            Sign out
          </button>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import AccountNav from '~/components/AccountNav.vue'

definePageMeta({
  middleware: 'auth'
})

const supabase = useSupabase()
const { user, signOut, checkAuth } = useAuth()

const sendingReset = ref(false)

const sendReset = async () => {
  await checkAuth()
  if (!user.value?.email) return

  sendingReset.value = true
  try {
    const { error } = await supabase.auth.resetPasswordForEmail(user.value.email, {
      redirectTo: window.location.origin + '/auth/update-password'
    })
    if (error) throw error
  } catch (error) {
    console.error('Error sending reset email:', error)
  } finally {
    sendingReset.value = false
  }
}

const handleSignOut = async () => {
  const result = await signOut()
  if (result.success) {
    navigateTo('/')
  }
}

useHead({
  title: 'Security - Account - Flux',
  meta: [
    {
      name: 'description',
      content: 'Manage authentication and account security'
    }
  ]
})
</script>
