<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-8">
        <NuxtLink to="/account" class="text-sm text-zinc-600 hover:text-zinc-900 mb-4 inline-block">
          &larr; Back to Account
        </NuxtLink>
        <h1 class="text-4xl font-bold text-zinc-900">Order History</h1>
      </div>

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
        <NuxtLink
          v-for="order in orders"
          :key="order.id"
          :to="`/orders/${order.id}`"
          class="card hover:shadow-lg transition-shadow cursor-pointer"
        >
          <div class="flex items-start justify-between mb-4">
            <div>
              <p class="text-sm text-zinc-600 mb-1">Order {{ order.order_number }}</p>
              <p class="text-lg font-semibold text-zinc-900">
                ${{ order.total.toFixed(2) }}
              </p>
            </div>
            <span
              class="px-3 py-1 rounded-full text-sm font-medium"
              :class="getStatusClass(order.status)"
            >
              {{ order.status.charAt(0).toUpperCase() + order.status.slice(1) }}
            </span>
          </div>

          <div class="text-sm text-zinc-600">
            Placed on {{ formatDate(order.created_at) }}
          </div>
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Package } from 'lucide-vue-next'
import type { Database } from '~/types/database'

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

const getStatusClass = (status: string) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800',
    processing: 'bg-blue-100 text-blue-800',
    shipped: 'bg-indigo-100 text-indigo-800',
    delivered: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800'
  }
  return classes[status as keyof typeof classes] || 'bg-zinc-100 text-zinc-800'
}

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

onMounted(async () => {
  await checkAuth()
  await fetchOrders()
})

useHead({
  title: 'Order History - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'View your order history'
    }
  ]
})
</script>
