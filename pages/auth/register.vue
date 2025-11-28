<template>
  <div class="min-h-screen bg-zinc-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full">
      <div class="text-center mb-8">
        <NuxtLink to="/" class="inline-block">
          <span class="text-3xl font-bold text-zinc-900">LiquidLogistics</span>
        </NuxtLink>
        <h2 class="mt-6 text-3xl font-bold text-zinc-900">Create your account</h2>
        <p class="mt-2 text-sm text-zinc-600">
          Already have an account?
          <NuxtLink to="/auth/login" class="font-medium text-zinc-900 hover:text-zinc-700">
            Sign in
          </NuxtLink>
        </p>
      </div>

      <div class="card">
        <form @submit.prevent="handleSignUp" class="space-y-6">
          <div v-if="errorMessage" class="p-4 bg-red-50 border border-red-200 rounded-lg">
            <p class="text-sm text-red-800">{{ errorMessage }}</p>
          </div>

          <div v-if="successMessage" class="p-4 bg-green-50 border border-green-200 rounded-lg">
            <p class="text-sm text-green-800">{{ successMessage }}</p>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label for="firstName" class="block text-sm font-medium text-zinc-900 mb-1">
                First Name
              </label>
              <input
                id="firstName"
                v-model="firstName"
                type="text"
                required
                class="input"
                placeholder="John"
              />
            </div>

            <div>
              <label for="lastName" class="block text-sm font-medium text-zinc-900 mb-1">
                Last Name
              </label>
              <input
                id="lastName"
                v-model="lastName"
                type="text"
                required
                class="input"
                placeholder="Doe"
              />
            </div>
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
              autocomplete="new-password"
              class="input"
              placeholder="At least 8 characters"
            />
          </div>

          <div>
            <label for="confirmPassword" class="block text-sm font-medium text-zinc-900 mb-1">
              Confirm Password
            </label>
            <input
              id="confirmPassword"
              v-model="confirmPassword"
              type="password"
              required
              autocomplete="new-password"
              class="input"
              placeholder="Confirm your password"
            />
          </div>

          <div v-if="false">
            <label for="accountType" class="block text-sm font-medium text-zinc-900 mb-1">
              Account Type
            </label>
            <select
              id="accountType"
              v-model="accountType"
              class="input"
            >
              <option value="b2c">Personal (B2C)</option>
              <option value="b2b">Business (B2B)</option>
            </select>
          </div>

          <div v-if="false">
            <label for="companyName" class="block text-sm font-medium text-zinc-900 mb-1">
              Company Name
            </label>
            <input
              id="companyName"
              v-model="companyName"
              type="text"
              class="input"
              placeholder="Your company name"
            />
          </div>

          <div class="flex items-start gap-2">
            <input
              id="terms"
              v-model="agreeToTerms"
              type="checkbox"
              required
              class="mt-1 rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
            />
            <label for="terms" class="text-sm text-zinc-700">
              I agree to the
              <NuxtLink to="/terms" class="font-medium text-zinc-900 hover:text-zinc-700">
                Terms of Service
              </NuxtLink>
              and
              <NuxtLink to="/privacy" class="font-medium text-zinc-900 hover:text-zinc-700">
                Privacy Policy
              </NuxtLink>
            </label>
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="btn btn-primary w-full py-3 disabled:opacity-50"
          >
            <span v-if="!loading">Create Account</span>
            <span v-else>Creating account...</span>
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { signUp } = useAuth()
const router = useRouter()

const firstName = ref('')
const lastName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const accountType = ref('b2c')
const companyName = ref('')
const agreeToTerms = ref(false)
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const handleSignUp = async () => {
  errorMessage.value = ''
  successMessage.value = ''

  if (password.value !== confirmPassword.value) {
    errorMessage.value = 'Passwords do not match'
    return
  }

  if (password.value.length < 8) {
    errorMessage.value = 'Password must be at least 8 characters'
    return
  }

  if (!agreeToTerms.value) {
    errorMessage.value = 'You must agree to the terms and conditions'
    return
  }

  loading.value = true

  const userData = {
    first_name: firstName.value,
    last_name: lastName.value,
    customer_type: accountType.value,
    company_name: accountType.value === 'b2b' ? companyName.value : null
  }

  const result = await signUp(email.value, password.value, userData)

  if (result.success) {
    successMessage.value = 'Account created successfully! Redirecting...'
    setTimeout(() => {
      router.push('/auth/login')
    }, 2000)
  } else {
    errorMessage.value = result.error || 'Failed to create account. Please try again.'
  }

  loading.value = false
}

useHead({
  title: 'Create Account - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Create your LiquidLogistics account'
    }
  ]
})
</script>
