<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-8">
        <NuxtLink to="/admin" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
          &larr; Back to Dashboard
        </NuxtLink>
        <h1 class="text-4xl font-bold text-zinc-900">Orders</h1>
      </div>

      <div class="card mb-6">
        <div class="flex flex-col sm:flex-row gap-4">
          <div class="flex-1">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search by order number..."
              class="input"
            />
          </div>
          <select v-model="statusFilter" class="input w-full sm:w-auto">
            <option value="">All Statuses</option>
            <option value="pending">Pending</option>
            <option value="processing">Processing</option>
            <option value="shipped">Shipped</option>
            <option value="delivered">Delivered</option>
            <option value="cancelled">Cancelled</option>
          </select>
          <button @click="fetchOrders" class="btn btn-secondary">
            <Search :size="20" />
          </button>
        </div>
      </div>

      <div v-if="loading" class="space-y-4">
        <div v-for="i in 5" :key="i" class="card animate-pulse">
          <div class="h-6 bg-zinc-200 rounded w-1/3 mb-2"></div>
          <div class="h-4 bg-zinc-200 rounded w-1/2"></div>
        </div>
      </div>

      <div v-else-if="orders.length === 0" class="card text-center py-12">
        <ShoppingBag :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">No orders found</h2>
        <p class="text-zinc-600">Orders will appear here when customers make purchases</p>
      </div>

      <div v-else class="card overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-zinc-50 border-b border-zinc-200">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Order
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Customer
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Date
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Total
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Status
                </th>
                <th class="px-6 py-3 text-right text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-zinc-200">
              <tr v-for="order in orders" :key="order.id" class="hover:bg-zinc-50">
                <td class="px-6 py-4">
                  <NuxtLink
                    :to="`/orders/${order.id}`"
                    class="font-mono text-sm font-medium text-zinc-900 hover:text-zinc-600"
                  >
                    {{ order.order_number }}
                  </NuxtLink>
                </td>
                <td class="px-6 py-4 text-sm text-zinc-900">
                  {{ order.shipping_address?.first_name }} {{ order.shipping_address?.last_name }}
                </td>
                <td class="px-6 py-4 text-sm text-zinc-600">
                  {{ formatDate(order.created_at) }}
                </td>
                <td class="px-6 py-4 text-sm font-medium text-zinc-900">
                  ${{ order.total.toFixed(2) }}
                </td>
                <td class="px-6 py-4">
                  <select
                    v-model="order.status"
                    @change="updateOrderStatus(order.id, order.status)"
                    class="text-xs px-2 py-1 rounded border-0 focus:ring-2 focus:ring-zinc-900"
                    :class="getStatusClass(order.status)"
                  >
                    <option value="pending">Pending</option>
                    <option value="processing">Processing</option>
                    <option value="shipped">Shipped</option>
                    <option value="delivered">Delivered</option>
                    <option value="cancelled">Cancelled</option>
                  </select>
                </td>
                <td class="px-6 py-4 text-right">
                  <NuxtLink :to="`/orders/${order.id}`" class="text-zinc-600 hover:text-zinc-900">
                    <Eye :size="18" />
                  </NuxtLink>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Search, ShoppingBag, Eye } from 'lucide-vue-next'
import type { Database } from '~/types/database'

type Order = Database['public']['Tables']['orders']['Row']

const supabase = useSupabase()

const loading = ref(true)
const orders = ref<Order[]>([])
const searchQuery = ref('')
const statusFilter = ref('')

const fetchOrders = async () => {
  loading.value = true
  try {
    let query = supabase.from('orders').select('*').order('created_at', { ascending: false })

    if (searchQuery.value) {
      query = query.ilike('order_number', `%${searchQuery.value}%`)
    }

    if (statusFilter.value) {
      query = query.eq('status', statusFilter.value)
    }

    const { data, error } = await query

    if (error) throw error
    orders.value = data || []
  } catch (error) {
    console.error('Error fetching orders:', error)
  } finally {
    loading.value = false
  }
}

const updateOrderStatus = async (orderId: string, newStatus: string) => {
  try {
    const { error } = await supabase
      .from('orders')
      .update({ status: newStatus })
      .eq('id', orderId)

    if (error) throw error
  } catch (error) {
    console.error('Error updating order status:', error)
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
    month: 'short',
    day: 'numeric'
  })
}

onMounted(() => {
  fetchOrders()
})

useHead({
  title: 'Manage Orders - Admin - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Manage orders in LiquidLogistics'
    }
  ]
})
</script>
