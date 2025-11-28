<template>
  <div class="min-h-screen bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="mb-8">
        <h1 class="text-4xl font-bold text-zinc-900 mb-2">Products</h1>
        <p class="text-lg text-zinc-600">Explore our curated selection of premium beverages</p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
        <aside class="lg:col-span-1">
          <div class="sticky top-24 space-y-6">
            <div>
              <h3 class="text-sm font-semibold text-zinc-900 mb-3">Categories</h3>
              <div class="space-y-2">
                <label
                  v-for="category in categories"
                  :key="category.id"
                  class="flex items-center gap-2 cursor-pointer"
                >
                  <input
                    type="checkbox"
                    :value="category.id"
                    v-model="selectedCategories"
                    class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                    @change="applyFilters"
                  />
                  <span class="text-sm text-zinc-700">{{ category.name }}</span>
                </label>
              </div>
            </div>

            <div>
              <h3 class="text-sm font-semibold text-zinc-900 mb-3">Price Range</h3>
              <div class="space-y-3">
                <div class="flex items-center gap-2">
                  <input
                    v-model.number="priceRange.min"
                    type="number"
                    placeholder="Min"
                    class="input py-2 text-sm"
                    @change="applyFilters"
                  />
                  <span class="text-zinc-500">-</span>
                  <input
                    v-model.number="priceRange.max"
                    type="number"
                    placeholder="Max"
                    class="input py-2 text-sm"
                    @change="applyFilters"
                  />
                </div>
              </div>
            </div>

            <div>
              <h3 class="text-sm font-semibold text-zinc-900 mb-3">Availability</h3>
              <label class="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  v-model="inStockOnly"
                  class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                  @change="applyFilters"
                />
                <span class="text-sm text-zinc-700">In stock only</span>
              </label>
            </div>

            <button
              @click="clearFilters"
              class="text-sm text-zinc-600 hover:text-zinc-900 transition-colors"
            >
              Clear all filters
            </button>
          </div>
        </aside>

        <main class="lg:col-span-3">
          <div class="flex items-center justify-between mb-6">
            <p class="text-sm text-zinc-600">
              {{ filteredProducts.length }} {{ filteredProducts.length === 1 ? 'product' : 'products' }}
            </p>

            <div class="flex items-center gap-2">
              <label for="sort" class="text-sm text-zinc-600">Sort by:</label>
              <select
                id="sort"
                v-model="sortBy"
                class="input py-2 text-sm w-auto"
                @change="applySort"
              >
                <option value="name-asc">Name: A-Z</option>
                <option value="name-desc">Name: Z-A</option>
                <option value="price-asc">Price: Low to High</option>
                <option value="price-desc">Price: High to Low</option>
                <option value="newest">Newest First</option>
              </select>
            </div>
          </div>

          <div v-if="loading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <div v-for="i in 6" :key="i" class="card animate-pulse">
              <div class="aspect-square bg-zinc-200 rounded-lg mb-4"></div>
              <div class="h-4 bg-zinc-200 rounded mb-2"></div>
              <div class="h-3 bg-zinc-200 rounded w-2/3"></div>
            </div>
          </div>

          <div
            v-else-if="filteredProducts.length > 0"
            class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"
          >
            <ProductCard
              v-for="product in filteredProducts"
              :key="product.id"
              :product="product"
            />
          </div>

          <div v-else class="text-center py-12">
            <p class="text-zinc-600 mb-4">No products found matching your filters.</p>
            <button @click="clearFilters" class="btn btn-outline">
              Clear filters
            </button>
          </div>
        </main>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']
type Category = Database['public']['Tables']['categories']['Row']

const supabase = useSupabase()
const route = useRoute()

const loading = ref(true)
const products = ref<Product[]>([])
const categories = ref<Category[]>([])
const filteredProducts = ref<Product[]>([])

const selectedCategories = ref<string[]>([])
const priceRange = ref({ min: null as number | null, max: null as number | null })
const inStockOnly = ref(false)
const sortBy = ref('name-asc')

const fetchProducts = async () => {
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('is_active', true)
      .order('name')

    if (error) throw error
    products.value = data || []
    applyFilters()
  } catch (error) {
    console.error('Error fetching products:', error)
  } finally {
    loading.value = false
  }
}

const fetchCategories = async () => {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name')

    if (error) throw error
    categories.value = data || []
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const applyFilters = () => {
  let filtered = [...products.value]

  if (selectedCategories.value.length > 0) {
    filtered = filtered.filter(p => p.category_id && selectedCategories.value.includes(p.category_id))
  }

  if (priceRange.value.min !== null) {
    filtered = filtered.filter(p => p.price >= priceRange.value.min!)
  }

  if (priceRange.value.max !== null) {
    filtered = filtered.filter(p => p.price <= priceRange.value.max!)
  }

  if (inStockOnly.value) {
    filtered = filtered.filter(p => p.stock_quantity > 0)
  }

  filteredProducts.value = filtered
  applySort()
}

const applySort = () => {
  const sorted = [...filteredProducts.value]

  switch (sortBy.value) {
    case 'name-asc':
      sorted.sort((a, b) => a.name.localeCompare(b.name))
      break
    case 'name-desc':
      sorted.sort((a, b) => b.name.localeCompare(a.name))
      break
    case 'price-asc':
      sorted.sort((a, b) => a.price - b.price)
      break
    case 'price-desc':
      sorted.sort((a, b) => b.price - a.price)
      break
    case 'newest':
      sorted.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
      break
  }

  filteredProducts.value = sorted
}

const clearFilters = () => {
  selectedCategories.value = []
  priceRange.value = { min: null, max: null }
  inStockOnly.value = false
  applyFilters()
}

onMounted(() => {
  fetchProducts()
  fetchCategories()
})

useHead({
  title: 'Products - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Browse our curated selection of premium beverages'
    }
  ]
})
</script>
