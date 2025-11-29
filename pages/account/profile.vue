<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-6">
        <NuxtLink to="/account" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
          &larr; Back to Account
        </NuxtLink>
        <h1 class="text-3xl font-bold text-zinc-900">Profile</h1>
      </div>

      <AccountNav />

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <section class="lg:col-span-2 card" aria-labelledby="profile-heading">
          <div class="mb-4">
            <h2 id="profile-heading" class="text-lg font-semibold text-zinc-900">Personal details</h2>
            <p class="text-sm text-zinc-600">Update the information used for orders and communication.</p>
          </div>

          <div v-if="loading" class="space-y-3">
            <div class="h-6 bg-zinc-200 rounded w-1/3"></div>
            <div class="h-4 bg-zinc-200 rounded w-1/2"></div>
          </div>

          <div v-else-if="customer" class="mt-2">
            <ProfileForm
              v-model="profileForm"
              :email="customer.email"
              :saving="saving"
              @submit="saveProfile"
            />
          </div>
        </section>

        <aside class="space-y-4">
          <div class="card">
            <h2 class="text-sm font-semibold text-zinc-900 mb-2">Account</h2>
            <p class="text-sm text-zinc-600 mb-2">
              Signed in as
            </p>
            <p class="text-sm font-mono text-zinc-900 break-all">
              {{ customer?.email || user?.email }}
            </p>
          </div>
        </aside>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import AccountNav from '~/components/AccountNav.vue'
import ProfileForm from '~/components/ProfileForm.vue'
import type { Database } from '~/types/database'

definePageMeta({
  middleware: 'auth'
})

type Customer = Database['public']['Tables']['customers']['Row']

const supabase = useSupabase()
const { user, checkAuth } = useAuth()

const loading = ref(true)
const saving = ref(false)
const customer = ref<Customer | null>(null)

const profileForm = reactive({
  first_name: '' as string | null,
  last_name: '' as string | null,
  phone: '' as string | null,
  company_name: '' as string | null
})

const fetchCustomer = async () => {
  await checkAuth()
  if (!user.value) {
    loading.value = false
    return
  }

  try {
    const { data, error } = await supabase
      .from('customers')
      .select('*')
      .eq('id', user.value.id)
      .maybeSingle<Customer>()

    if (error) throw error
    customer.value = data

    if (data) {
      profileForm.first_name = data.first_name
      profileForm.last_name = data.last_name
      profileForm.phone = data.phone
      profileForm.company_name = data.company_name
    }
  } catch (error) {
    console.error('Error fetching customer:', error)
  } finally {
    loading.value = false
  }
}

const saveProfile = async () => {
  if (!user.value) return
  saving.value = true

  try {
    const { error } = await supabase
      .from('customers')
      .update({
        first_name: profileForm.first_name,
        last_name: profileForm.last_name,
        phone: profileForm.phone,
        company_name: profileForm.company_name
      })
      .eq('id', user.value.id)

    if (error) throw error

    await fetchCustomer()
  } catch (error) {
    console.error('Error updating profile:', error)
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchCustomer()
})

useHead({
  title: 'Profile - Account - Flux',
  meta: [
    {
      name: 'description',
      content: 'Manage your personal details'
    }
  ]
})
</script>
