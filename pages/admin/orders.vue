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
                    @change="handleStatusChange(order)"
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
                  <button
                    type="button"
                    class="text-zinc-600 hover:text-zinc-900"
                    @click="openOrderDetails(order)"
                  >
                    <Eye :size="18" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Order details drawer -->
      <div
        v-if="selectedOrder"
        class="fixed inset-0 z-40 flex items-stretch justify-end bg-black/40"
        role="dialog"
        aria-modal="true"
      >
        <div class="w-full max-w-xl bg-white shadow-2xl h-full overflow-y-auto">
          <div class="border-b border-zinc-200 px-6 py-4 flex items-center justify-between">
            <div>
              <p class="text-xs font-medium text-zinc-500 uppercase tracking-[0.2em]">
                Order
              </p>
              <h2 class="text-lg font-semibold text-zinc-900">
                {{ selectedOrder.order_number }}
              </h2>
              <p class="text-xs text-zinc-500">
                Placed {{ formatDate(selectedOrder.created_at) }}
              </p>
            </div>
            <button
              type="button"
              class="rounded-full p-1.5 text-zinc-500 hover:bg-zinc-100 hover:text-zinc-900 focus:outline-none focus:ring-2 focus:ring-zinc-900"
              @click="closeOrderDetails"
              aria-label="Close order details"
            >
              <X :size="18" />
            </button>
          </div>

          <div class="px-6 py-4 space-y-6">
            <!-- Status & totals -->
            <section class="flex flex-col gap-2">
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                  <span class="text-xs font-medium text-zinc-500 uppercase tracking-[0.2em]">
                    Status
                  </span>
                  <span
                    class="inline-flex items-center rounded-full px-2 py-1 text-xs font-medium"
                    :class="getStatusClass(selectedOrder.status)"
                  >
                    {{ selectedOrder.status }}
                  </span>
                </div>
                <p class="text-sm font-semibold text-zinc-900">
                  Total ${{ selectedOrder.total.toFixed(2) }}
                </p>
              </div>
            </section>

            <!-- Line items -->
            <section>
              <h3 class="text-sm font-semibold text-zinc-900 mb-2">
                Items
              </h3>

              <div v-if="loadingItems" class="space-y-3">
                <div v-for="i in 3" :key="i" class="flex justify-between items-center">
                  <div class="space-y-1 flex-1">
                    <div class="h-4 bg-zinc-200 rounded w-2/3"></div>
                    <div class="h-3 bg-zinc-100 rounded w-1/3"></div>
                  </div>
                  <div class="h-4 bg-zinc-200 rounded w-16 ml-4"></div>
                </div>
              </div>

              <div v-else-if="orderItems.length === 0" class="text-sm text-zinc-500">
                No items found for this order.
              </div>

              <ul v-else class="divide-y divide-zinc-200">
                <li
                  v-for="item in orderItems"
                  :key="item.id"
                  class="py-3 flex items-start justify-between gap-3"
                >
                  <div class="flex-1">
                    <p class="text-sm font-medium text-zinc-900">
                      {{ item.product_snapshot?.name || 'Product' }}
                    </p>
                    <p class="text-xs text-zinc-500">
                      Qty {{ item.quantity }} · ${{ item.unit_price.toFixed(2) }} each
                    </p>
                  </div>
                  <p class="text-sm font-semibold text-zinc-900">
                    ${{ item.subtotal.toFixed(2) }}
                  </p>
                </li>
              </ul>
            </section>

            <!-- Addresses -->
            <section class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <h3 class="text-sm font-semibold text-zinc-900 mb-1">
                  Shipping
                </h3>
                <p class="text-xs text-zinc-700 whitespace-pre-line">
                  {{ formatAddress(selectedOrder.shipping_address) }}
                </p>
              </div>
              <div>
                <h3 class="text-sm font-semibold text-zinc-900 mb-1">
                  Billing
                </h3>
                <p class="text-xs text-zinc-700 whitespace-pre-line">
                  {{ formatAddress(selectedOrder.billing_address) }}
                </p>
              </div>
            </section>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Search, ShoppingBag, Eye, X } from 'lucide-vue-next'
import type { Database } from '~/types/database'

definePageMeta({
  middleware: 'admin'
})

type Order = Database['public']['Tables']['orders']['Row']
type OrderItem = Database['public']['Tables']['order_items']['Row']

const supabase = useSupabase()

const loading = ref(true)
const orders = ref<Order[]>([])
const searchQuery = ref('')
const statusFilter = ref('')
const previousStatuses = reactive<Record<string, Order['status']>>({})

const selectedOrder = ref<Order | null>(null)
const orderItems = ref<OrderItem[]>([])
const loadingItems = ref(false)

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

    // Track previous statuses so we can safely revert on failed updates
    for (const order of orders.value) {
      previousStatuses[order.id] = order.status
    }
  } catch (error) {
    console.error('Error fetching orders:', error)
  } finally {
    loading.value = false
  }
}

const openOrderDetails = async (order: Order) => {
  selectedOrder.value = order
  loadingItems.value = true
  orderItems.value = []

  try {
    const { data, error } = await supabase
      .from('order_items')
      .select('*')
      .eq('order_id', order.id)
      .order('created_at', { ascending: true })

    if (error) throw error
    orderItems.value = (data || []) as OrderItem[]
  } catch (error) {
    console.error('Error fetching order items:', error)
  } finally {
    loadingItems.value = false
  }
}

const closeOrderDetails = () => {
  selectedOrder.value = null
  orderItems.value = []
}

const handleStatusChange = async (order: Order) => {
  const orderId = order.id
  const newStatus = order.status
  const previousStatus = previousStatuses[orderId]

  const confirmed = window.confirm(
    `Change status for order ${order.order_number} from "${previousStatus}" to "${newStatus}"?`
  )

  if (!confirmed) {
    // Revert selection if user cancels
    order.status = previousStatus
    return
  }

  try {
    const { error } = await supabase
      .from('orders')
      .update({ status: newStatus })
      .eq('id', orderId)

    if (error) throw error

    previousStatuses[orderId] = newStatus
  } catch (error) {
    console.error('Error updating order status:', error)
    // Revert to previous known good status on failure
    order.status = previousStatus
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

const formatAddress = (address: any) => {
  if (!address) return '—'

  const parts = [
    [address.first_name, address.last_name].filter(Boolean).join(' '),
    address.address_line1,
    address.address_line2,
    [address.city, address.state].filter(Boolean).join(', '),
    address.postal_code,
    address.country,
    address.phone
  ].filter(Boolean)

  return parts.join('\n')
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
  title: 'Manage Orders - Admin - Flux',
  meta: [
    {
      name: 'description',
      content: 'Manage orders in Flux'
    }
  ]
})
</script>
