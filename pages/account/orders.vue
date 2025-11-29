<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-6">
        <NuxtLink to="/account" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
          &larr; Back to Account
        </NuxtLink>
        <h1 class="text-3xl font-bold text-zinc-900">Order History</h1>
      </div>

      <AccountNav />

      <div v-if="loading" class="space-y-4">
        <div v-for="i in 3" :key="i" class="card animate-pulse">
          <div class="h-6 bg-zinc-200 rounded w-1/3 mb-3"></div>
          <div class="h-4 bg-zinc-200 rounded w-1/4"></div>
        </div>
      </div>

      <div v-else-if="orders.length === 0" class="card text-center py-12">
        <Package :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">No orders yet</h2>
        <p class="text-zinc-600 mb-6">Start shopping to see your orders here</p>
        <NuxtLink to="/products" class="btn btn-primary">
          Browse Products
        </NuxtLink>
      </div>

      <div v-else class="space-y-4">
        <OrderCard
          v-for="order in orders"
          :key="order.id"
          :order="order"
          :to="`/orders/${order.id}`"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Package } from 'lucide-vue-next'
import type { Database } from '~/types/database'
import AccountNav from '~/components/AccountNav.vue'
import OrderCard from '~/components/OrderCard.vue'

definePageMeta({
  middleware: 'auth'
})

type Order = Database['public']['Tables']['orders']['Row']

const supabase = useSupabase()
const { user, checkAuth } = useAuth()

const loading = ref(true)
const orders = ref<Order[]>([])

const fetchOrders = async () => {
  if (!user.value) return

  try {
    const { data, error } = await supabase
      .from('orders')
      .select('*')
      .eq('customer_id', user.value.id)
      .order('created_at', { ascending: false })

    if (error) throw error
    orders.value = data || []
  } catch (error) {
    console.error('Error fetching orders:', error)
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  await checkAuth()
  await fetchOrders()
})

useHead({
  title: 'Order History - Flux',
  meta: [
    {
      name: 'description',
      content: 'View your order history'
    }
  ]
})
</script>
