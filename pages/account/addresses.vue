<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-6">
        <NuxtLink to="/account" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
          &larr; Back to Account
        </NuxtLink>
        <h1 class="text-3xl font-bold text-zinc-900">Addresses</h1>
      </div>

      <AccountNav />

      <div class="flex items-center justify-between mb-4">
        <p class="text-sm text-zinc-600">
          Manage shipping and billing addresses used at checkout.
        </p>
        <button class="btn btn-primary" @click="openAddModal">
          Add address
        </button>
      </div>

      <div v-if="loading" class="space-y-4">
        <div v-for="i in 3" :key="i" class="card animate-pulse">
          <div class="h-6 bg-zinc-200 rounded w-1/3 mb-2"></div>
          <div class="h-4 bg-zinc-200 rounded w-1/2"></div>
        </div>
      </div>

      <div v-else-if="addresses.length === 0" class="card text-center py-12">
        <p class="text-zinc-600 mb-4">You have no saved addresses yet.</p>
        <button class="btn btn-primary" @click="openAddModal">Add your first address</button>
      </div>

      <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <AddressCard
          v-for="address in addresses"
          :key="address.id"
          :address="address"
          @edit="openEditModal(address)"
          @delete="confirmDelete(address)"
          @make-default="makeDefault(address)"
        />
      </div>

      <!-- Add / Edit modal -->
      <div
        v-if="showModal"
        class="fixed inset-0 z-40 flex items-center justify-center bg-black/40 px-4 sm:px-6 lg:px-8"
        role="dialog"
        aria-modal="true"
      >
        <div class="w-full max-w-xl rounded-2xl bg-white p-6 shadow-2xl max-h-[90vh] overflow-y-auto">
          <div class="flex items-start justify-between mb-4">
            <div>
              <h2 class="text-xl font-semibold text-zinc-900 mb-1">
                {{ editing ? 'Edit address' : 'New address' }}
              </h2>
              <p class="text-sm text-zinc-600">Used for shipping, billing and invoices.</p>
            </div>
            <button
              type="button"
              class="rounded-full p-1.5 text-zinc-500 hover:bg-zinc-100 hover:text-zinc-900 focus:outline-none focus:ring-2 focus:ring-zinc-900"
              @click="closeModal"
              aria-label="Close"
            >
              <X :size="18" />
            </button>
          </div>

          <form class="space-y-4" @submit.prevent="saveAddress">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="first_name">First name</label>
                <input id="first_name" v-model="form.first_name" type="text" required class="input" />
              </div>
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="last_name">Last name</label>
                <input id="last_name" v-model="form.last_name" type="text" required class="input" />
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="company">Company (optional)</label>
              <input id="company" v-model="form.company" type="text" class="input" />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="address1">Address line 1</label>
              <input id="address1" v-model="form.address_line1" type="text" required class="input" />
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="address2">Address line 2</label>
              <input id="address2" v-model="form.address_line2" type="text" class="input" />
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="city">City</label>
                <input id="city" v-model="form.city" type="text" required class="input" />
              </div>
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="state">State</label>
                <input id="state" v-model="form.state" type="text" required class="input" />
              </div>
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="postal">Postal code</label>
                <input id="postal" v-model="form.postal_code" type="text" required class="input" />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="country">Country</label>
                <input id="country" v-model="form.country" type="text" required class="input" />
              </div>
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="phone">Phone</label>
                <input id="phone" v-model="form.phone" type="tel" required class="input" />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="type">Type</label>
                <select id="type" v-model="form.address_type" class="input">
                  <option value="shipping">Shipping</option>
                  <option value="billing">Billing</option>
                </select>
              </div>
              <div class="flex items-center gap-2 pt-6">
                <input
                  id="default"
                  v-model="form.is_default"
                  type="checkbox"
                  class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                />
                <label for="default" class="text-sm text-zinc-900">Set as default</label>
              </div>
            </div>

            <div class="flex items-center justify-end gap-3 pt-2">
              <button type="button" class="btn btn-secondary" @click="closeModal">Cancel</button>
              <button type="submit" class="btn btn-primary">
                {{ saving ? 'Saving…' : editing ? 'Save changes' : 'Create address' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { X } from 'lucide-vue-next'
import AccountNav from '~/components/AccountNav.vue'
import AddressCard from '~/components/AddressCard.vue'
import type { Database } from '~/types/database'

definePageMeta({
  middleware: 'auth'
})

type Address = Database['public']['Tables']['addresses']['Row']

const supabase = useSupabase()
const { user, checkAuth } = useAuth()

const loading = ref(true)
const saving = ref(false)
const addresses = ref<Address[]>([])

const showModal = ref(false)
const editing = ref<Address | null>(null)

const form = reactive({
  first_name: '',
  last_name: '',
  company: '',
  address_line1: '',
  address_line2: '',
  city: '',
  state: '',
  postal_code: '',
  country: '',
  phone: '',
  address_type: 'shipping' as Address['address_type'],
  is_default: false
})

const fetchAddresses = async () => {
  await checkAuth()
  if (!user.value) {
    loading.value = false
    return
  }

  try {
    const { data, error } = await supabase
      .from('addresses')
      .select('*')
      .eq('customer_id', user.value.id)
      .order('created_at', { ascending: false })

    if (error) throw error
    addresses.value = (data || []) as Address[]
  } catch (error) {
    console.error('Error fetching addresses:', error)
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  form.first_name = ''
  form.last_name = ''
  form.company = ''
  form.address_line1 = ''
  form.address_line2 = ''
  form.city = ''
  form.state = ''
  form.postal_code = ''
  form.country = ''
  form.phone = ''
  form.address_type = 'shipping'
  form.is_default = false
}

const openAddModal = () => {
  editing.value = null
  resetForm()
  showModal.value = true
}

const openEditModal = (address: Address) => {
  editing.value = address
  form.first_name = address.first_name
  form.last_name = address.last_name
  form.company = address.company || ''
  form.address_line1 = address.address_line1
  form.address_line2 = address.address_line2 || ''
  form.city = address.city
  form.state = address.state
  form.postal_code = address.postal_code
  form.country = address.country
  form.phone = address.phone
  form.address_type = address.address_type
  form.is_default = address.is_default
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const saveAddress = async () => {
  if (!user.value) return
  saving.value = true

  try {
    const payload: Partial<Address> = {
      customer_id: user.value.id,
      first_name: form.first_name,
      last_name: form.last_name,
      company: form.company || null,
      address_line1: form.address_line1,
      address_line2: form.address_line2 || null,
      city: form.city,
      state: form.state,
      postal_code: form.postal_code,
      country: form.country,
      phone: form.phone,
      address_type: form.address_type,
      is_default: form.is_default
    }

    if (editing.value) {
      const { error } = await supabase
        .from('addresses')
        .update(payload)
        .eq('id', editing.value.id)

      if (error) throw error
    } else {
      const { error } = await supabase
        .from('addresses')
        .insert(payload)

      if (error) throw error
    }

    await fetchAddresses()
    showModal.value = false
  } catch (error) {
    console.error('Error saving address:', error)
  } finally {
    saving.value = false
  }
}

const confirmDelete = async (address: Address) => {
  if (!window.confirm('Delete this address?')) return

  try {
    const { error } = await supabase
      .from('addresses')
      .delete()
      .eq('id', address.id)

    if (error) throw error
    await fetchAddresses()
  } catch (error) {
    console.error('Error deleting address:', error)
  }
}

const makeDefault = async (address: Address) => {
  if (!user.value) return

  try {
    // Clear existing default for this type
    await supabase
      .from('addresses')
      .update({ is_default: false })
      .eq('customer_id', user.value.id)
      .eq('address_type', address.address_type)

    const { error } = await supabase
      .from('addresses')
      .update({ is_default: true })
      .eq('id', address.id)

    if (error) throw error

    await fetchAddresses()
  } catch (error) {
    console.error('Error setting default address:', error)
  }
}

onMounted(() => {
  fetchAddresses()
})

useHead({
  title: 'Addresses - Account - Flux',
  meta: [
    {
      name: 'description',
      content: 'Manage your saved addresses'
    }
  ]
})
</script>
