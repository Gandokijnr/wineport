<template>
  <div v-if="loading" class="min-h-screen bg-white">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="animate-pulse space-y-4">
        <div class="h-8 bg-zinc-200 rounded w-1/3"></div>
        <div class="h-4 bg-zinc-200 rounded w-1/4"></div>
      </div>
    </div>
  </div>

  <div v-else-if="order" class="min-h-screen bg-white">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="text-center mb-12">
        <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
          <CheckCircle :size="32" class="text-green-600" />
        </div>
        <h1 class="text-3xl font-bold text-zinc-900 mb-2">Order Confirmed!</h1>
        <p class="text-lg text-zinc-600">
          Thank you for your order. Your order number is <span class="font-mono font-semibold">{{ order.order_number }}</span>
        </p>
      </div>

      <div class="space-y-6">
        <div class="card">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-zinc-900">Order Details</h2>
            <span
              class="px-3 py-1 rounded-full text-sm font-medium"
              :class="getStatusClass(order.status)"
            >
              {{ order.status.charAt(0).toUpperCase() + order.status.slice(1) }}
            </span>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 text-sm">
            <div>
              <span class="text-zinc-600">Order Date:</span>
              <p class="font-medium text-zinc-900">{{ formatDate(order.created_at) }}</p>
            </div>
            <div>
              <span class="text-zinc-600">Payment Status:</span>
              <p class="font-medium text-zinc-900">
                {{ order.payment_status.charAt(0).toUpperCase() + order.payment_status.slice(1) }}
              </p>
            </div>
          </div>
        </div>

        <div class="card">
          <h2 class="text-xl font-bold text-zinc-900 mb-4">Order Items</h2>
          <div class="space-y-4">
            <div
              v-for="item in orderItems"
              :key="item.id"
              class="flex items-center gap-4 pb-4 border-b border-zinc-200 last:border-0 last:pb-0"
            >
              <div class="w-16 h-16 bg-zinc-100 rounded flex-shrink-0">
                <img
                  v-if="item.product_snapshot?.image_urls?.[0]"
                  :src="item.product_snapshot.image_urls[0]"
                  :alt="item.product_snapshot?.name"
                  class="w-full h-full object-cover rounded"
                />
              </div>
              <div class="flex-1 min-w-0">
                <p class="font-medium text-zinc-900">{{ item.product_snapshot?.name }}</p>
                <p class="text-sm text-zinc-600">Quantity: {{ item.quantity }}</p>
              </div>
              <div class="text-right">
                <p class="font-medium text-zinc-900">${item.subtotal.toFixed(2)}</p>
                <p class="text-sm text-zinc-600">${item.unit_price.toFixed(2)} each</p>
              </div>
            </div>
          </div>

          <div class="mt-6 pt-6 border-t border-zinc-200 space-y-2">
            <div class="flex items-center justify-between text-sm">
              <span class="text-zinc-600">Subtotal</span>
              <span class="font-medium text-zinc-900">${order.subtotal.toFixed(2)}</span>
            </div>
            <div class="flex items-center justify-between text-sm">
              <span class="text-zinc-600">Shipping</span>
              <span class="font-medium text-zinc-900">${order.shipping_cost.toFixed(2)}</span>
            </div>
            <div class="flex items-center justify-between text-sm">
              <span class="text-zinc-600">Tax</span>
              <span class="font-medium text-zinc-900">${order.tax.toFixed(2)}</span>
            </div>
            <div v-if="order.discount > 0" class="flex items-center justify-between text-sm">
              <span class="text-zinc-600">Discount</span>
              <span class="font-medium text-green-600">-${{ order.discount.toFixed(2) }}</span>
            </div>
            <div class="flex items-center justify-between text-lg font-bold pt-2 border-t border-zinc-200">
              <span class="text-zinc-900">Total</span>
              <span class="text-zinc-900">${order.total.toFixed(2)}</span>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="card">
            <h2 class="text-lg font-bold text-zinc-900 mb-4">Shipping Address</h2>
            <div class="text-sm text-zinc-700 space-y-1">
              <p>{{ order.shipping_address.first_name }} {{ order.shipping_address.last_name }}</p>
              <p v-if="order.shipping_address.company">{{ order.shipping_address.company }}</p>
              <p>{{ order.shipping_address.address_line1 }}</p>
              <p v-if="order.shipping_address.address_line2">{{ order.shipping_address.address_line2 }}</p>
              <p>
                {{ order.shipping_address.city }}, {{ order.shipping_address.state }}
                {{ order.shipping_address.postal_code }}
              </p>
              <p>{{ order.shipping_address.country }}</p>
              <p class="pt-2">{{ order.shipping_address.phone }}</p>
            </div>
          </div>

          <div class="card">
            <h2 class="text-lg font-bold text-zinc-900 mb-4">Billing Address</h2>
            <div class="text-sm text-zinc-700 space-y-1">
              <p>{{ order.billing_address.first_name }} {{ order.billing_address.last_name }}</p>
              <p v-if="order.billing_address.company">{{ order.billing_address.company }}</p>
              <p>{{ order.billing_address.address_line1 }}</p>
              <p v-if="order.billing_address.address_line2">{{ order.billing_address.address_line2 }}</p>
              <p>
                {{ order.billing_address.city }}, {{ order.billing_address.state }}
                {{ order.billing_address.postal_code }}
              </p>
              <p>{{ order.billing_address.country }}</p>
            </div>
          </div>
        </div>

        <div v-if="order.notes" class="card">
          <h2 class="text-lg font-bold text-zinc-900 mb-2">Order Notes</h2>
          <p class="text-sm text-zinc-700">{{ order.notes }}</p>
        </div>

        <div class="flex items-center justify-center gap-4">
          <NuxtLink to="/products" class="btn btn-primary">
            Continue Shopping
          </NuxtLink>
          <NuxtLink to="/account/orders" class="btn btn-secondary">
            View All Orders
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>

  <div v-else class="min-h-screen bg-white flex items-center justify-center">
    <div class="text-center">
      <h1 class="text-2xl font-bold text-zinc-900 mb-2">Order Not Found</h1>
      <p class="text-zinc-600 mb-6">The order you're looking for doesn't exist.</p>
      <NuxtLink to="/products" class="btn btn-primary">
        Browse Products
      </NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { CheckCircle } from 'lucide-vue-next'
import type { Database } from '~/types/database'

type Order = Database['public']['Tables']['orders']['Row']
type OrderItem = Database['public']['Tables']['order_items']['Row']

const route = useRoute()
const supabase = useSupabase()

const loading = ref(true)
const order = ref<Order | null>(null)
const orderItems = ref<OrderItem[]>([])

const fetchOrder = async () => {
  try {
    const { data: orderData, error: orderError } = await supabase
      .from('orders')
      .select('*')
      .eq('id', route.params.id)
      .maybeSingle()

    if (orderError) throw orderError

    order.value = orderData

    if (orderData) {
      const { data: itemsData, error: itemsError } = await supabase
        .from('order_items')
        .select('*')
        .eq('order_id', orderData.id)

      if (itemsError) throw itemsError
      orderItems.value = itemsData || []
    }
  } catch (error) {
    console.error('Error fetching order:', error)
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
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(() => {
  fetchOrder()
})

watchEffect(() => {
  if (order.value) {
    useHead({
      title: `Order ${order.value.order_number} - LiquidLogistics`,
      meta: [
        {
          name: 'description',
          content: `Order details for ${order.value.order_number}`
        }
      ]
    })
  }
})
</script>
