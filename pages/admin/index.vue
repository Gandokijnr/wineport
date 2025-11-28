<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <h1 class="text-4xl font-bold text-zinc-900 mb-8">Admin Dashboard</h1>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div class="card">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-zinc-600">Total Orders</h3>
            <ShoppingBag class="text-zinc-400" :size="20" />
          </div>
          <p class="text-3xl font-bold text-zinc-900">{{ stats.totalOrders }}</p>
          <p class="text-sm text-zinc-600 mt-1">All time</p>
        </div>

        <div class="card">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-zinc-600">Revenue</h3>
            <DollarSign class="text-zinc-400" :size="20" />
          </div>
          <p class="text-3xl font-bold text-zinc-900">${stats.totalRevenue.toFixed(2)}</p>
          <p class="text-sm text-zinc-600 mt-1">All time</p>
        </div>

        <div class="card">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-zinc-600">Products</h3>
            <Package class="text-zinc-400" :size="20" />
          </div>
          <p class="text-3xl font-bold text-zinc-900">{{ stats.totalProducts }}</p>
          <p class="text-sm text-zinc-600 mt-1">In catalog</p>
        </div>

        <div class="card">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-medium text-zinc-600">Customers</h3>
            <Users class="text-zinc-400" :size="20" />
          </div>
          <p class="text-3xl font-bold text-zinc-900">{{ stats.totalCustomers }}</p>
          <p class="text-sm text-zinc-600 mt-1">Registered</p>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <NuxtLink to="/admin/products" class="card hover:shadow-lg transition-shadow cursor-pointer">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 bg-zinc-900 rounded-lg flex items-center justify-center">
              <Package class="text-white" :size="24" />
            </div>
            <div>
              <h3 class="text-lg font-semibold text-zinc-900">Products</h3>
              <p class="text-sm text-zinc-600">Manage inventory</p>
            </div>
          </div>
        </NuxtLink>

        <NuxtLink to="/admin/orders" class="card hover:shadow-lg transition-shadow cursor-pointer">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 bg-zinc-900 rounded-lg flex items-center justify-center">
              <ShoppingBag class="text-white" :size="24" />
            </div>
            <div>
              <h3 class="text-lg font-semibold text-zinc-900">Orders</h3>
              <p class="text-sm text-zinc-600">Process orders</p>
            </div>
          </div>
        </NuxtLink>

        <NuxtLink to="/admin/categories" class="card hover:shadow-lg transition-shadow cursor-pointer">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-12 h-12 bg-zinc-900 rounded-lg flex items-center justify-center">
              <Layers class="text-white" :size="24" />
            </div>
            <div>
              <h3 class="text-lg font-semibold text-zinc-900">Categories</h3>
              <p class="text-sm text-zinc-600">Organize products</p>
            </div>
          </div>
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ShoppingBag, Package, Users, DollarSign, Layers } from 'lucide-vue-next'

const supabase = useSupabase()

const stats = ref({
  totalOrders: 0,
  totalRevenue: 0,
  totalProducts: 0,
  totalCustomers: 0
})

const fetchStats = async () => {
  try {
    const [ordersRes, productsRes, customersRes] = await Promise.all([
      supabase.from('orders').select('total', { count: 'exact' }),
      supabase.from('products').select('id', { count: 'exact' }),
      supabase.from('customers').select('id', { count: 'exact' })
    ])

    stats.value.totalOrders = ordersRes.count || 0
    stats.value.totalProducts = productsRes.count || 0
    stats.value.totalCustomers = customersRes.count || 0

    if (ordersRes.data) {
      stats.value.totalRevenue = ordersRes.data.reduce((sum, order) => sum + order.total, 0)
    }
  } catch (error) {
    console.error('Error fetching stats:', error)
  }
}

onMounted(() => {
  fetchStats()
})

useHead({
  title: 'Admin Dashboard - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Admin dashboard for managing LiquidLogistics'
    }
  ]
})
</script>
