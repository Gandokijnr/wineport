<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="flex items-center justify-between mb-8">
        <div>
          <NuxtLink to="/admin" class="text-sm text-zinc-600 hover:text-zinc-900 mb-2 inline-block">
            &larr; Back to Dashboard
          </NuxtLink>
          <h1 class="text-4xl font-bold text-zinc-900">Products</h1>
        </div>
        <button class="btn btn-primary" @click="showAddModal = true">
          <Plus :size="20" class="mr-2" />
          Add Product
        </button>
      </div>

      <div class="card mb-6">
        <div class="flex items-center gap-4">
          <div class="flex-1">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search products..."
              class="input"
            />
          </div>
          <button @click="fetchProducts" class="btn btn-secondary">
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

      <div v-else-if="products.length === 0" class="card text-center py-12">
        <Package :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">No products found</h2>
        <p class="text-zinc-600 mb-6">Start by adding your first product</p>
      </div>

      <div v-else class="card overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-zinc-50 border-b border-zinc-200">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Product
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  SKU
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Price
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-zinc-600 uppercase tracking-wider">
                  Stock
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
              <tr v-for="product in products" :key="product.id" class="hover:bg-zinc-50">
                <td class="px-6 py-4">
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-zinc-100 rounded flex-shrink-0">
                      <img
                        v-if="product.image_urls?.[0]"
                        :src="product.image_urls[0]"
                        :alt="product.name"
                        class="w-full h-full object-cover rounded"
                      />
                    </div>
                    <div>
                      <p class="font-medium text-zinc-900">{{ product.name }}</p>
                      <p class="text-sm text-zinc-600">{{ product.brand }}</p>
                    </div>
                  </div>
                </td>
                <td class="px-6 py-4 text-sm text-zinc-900 font-mono">
                  {{ product.sku }}
                </td>
                <td class="px-6 py-4 text-sm text-zinc-900 font-medium">
                  ${{ product.price.toFixed(2) }}
                </td>
                <td class="px-6 py-4 text-sm">
                  <span
                    :class="product.stock_quantity <= product.low_stock_threshold ? 'text-orange-600' : 'text-zinc-900'"
                  >
                    {{ product.stock_quantity }}
                  </span>
                </td>
                <td class="px-6 py-4">
                  <span
                    class="px-2 py-1 text-xs rounded-full"
                    :class="product.is_active ? 'bg-green-100 text-green-800' : 'bg-zinc-100 text-zinc-800'"
                  >
                    {{ product.is_active ? 'Active' : 'Inactive' }}
                  </span>
                </td>
                <td class="px-6 py-4 text-right">
                  <button class="text-zinc-600 hover:text-zinc-900 mr-2">
                    <Edit2 :size="18" />
                  </button>
                  <button class="text-zinc-600 hover:text-red-600">
                    <Trash2 :size="18" />
                  </button>
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
import { Plus, Search, Package, Edit2, Trash2 } from 'lucide-vue-next'
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']

const supabase = useSupabase()

const loading = ref(true)
const products = ref<Product[]>([])
const searchQuery = ref('')
const showAddModal = ref(false)

const fetchProducts = async () => {
  loading.value = true
  try {
    let query = supabase.from('products').select('*').order('created_at', { ascending: false })

    if (searchQuery.value) {
      query = query.ilike('name', `%${searchQuery.value}%`)
    }

    const { data, error } = await query

    if (error) throw error
    products.value = data || []
  } catch (error) {
    console.error('Error fetching products:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchProducts()
})

useHead({
  title: 'Manage Products - Admin - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Manage products in LiquidLogistics'
    }
  ]
})
</script>
