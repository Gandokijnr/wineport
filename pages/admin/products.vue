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
        <button class="btn btn-primary" @click="openAddModal">
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
                  <button
                    class="text-zinc-600 hover:text-zinc-900 mr-2"
                    @click="openEditModal(product)"
                  >
                    <Edit2 :size="18" />
                  </button>
                  <button
                    class="text-zinc-600 hover:text-red-600"
                    @click="confirmDelete(product)"
                  >
                    <Trash2 :size="18" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Add / Edit Product Modal -->
      <div
        v-if="showModal"
        class="fixed inset-0 z-40 flex items-center justify-center bg-black/40 px-4 sm:px-6 lg:px-8"
        role="dialog"
        aria-modal="true"
      >
        <div class="w-full max-w-3xl rounded-2xl bg-white p-6 shadow-2xl max-h-[90vh] overflow-y-auto">
          <div class="flex items-start justify-between mb-4">
            <div>
              <h2 class="text-xl font-semibold text-zinc-900 mb-1">
                {{ editingProduct ? 'Edit product' : 'Add product' }}
              </h2>
              <p class="text-sm text-zinc-600">
                Manage core product details used across the storefront and checkout.
              </p>
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

          <form class="space-y-4" @submit.prevent="saveProduct">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="name">Name</label>
                <input
                  id="name"
                  v-model="productForm.name"
                  type="text"
                  required
                  class="input"
                  placeholder="e.g. Bordeaux Blend 2018"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="slug">Slug</label>
                <input
                  id="slug"
                  v-model="productForm.slug"
                  type="text"
                  required
                  class="input"
                  placeholder="e.g. bordeaux-blend-2018"
                />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="sku">SKU</label>
                <input
                  id="sku"
                  v-model="productForm.sku"
                  type="text"
                  required
                  class="input font-mono"
                  placeholder="e.g. WIN-001"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="brand">Brand</label>
                <input
                  id="brand"
                  v-model="productForm.brand"
                  type="text"
                  class="input"
                  placeholder="Producer or house"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="price">Price</label>
                <input
                  id="price"
                  v-model.number="productForm.price"
                  type="number"
                  min="0"
                  step="0.01"
                  required
                  class="input"
                  placeholder="0.00"
                />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="stock">Stock quantity</label>
                <input
                  id="stock"
                  v-model.number="productForm.stock_quantity"
                  type="number"
                  min="0"
                  class="input"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-zinc-900 mb-1" for="threshold">Low stock threshold</label>
                <input
                  id="threshold"
                  v-model.number="productForm.low_stock_threshold"
                  type="number"
                  min="0"
                  class="input"
                />
              </div>

              <div class="flex items-center gap-4 pt-6">
                <label class="inline-flex items-center gap-2 text-sm text-zinc-900">
                  <input
                    v-model="productForm.is_featured"
                    type="checkbox"
                    class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                  />
                  <span>Featured</span>
                </label>
                <label class="inline-flex items-center gap-2 text-sm text-zinc-900">
                  <input
                    v-model="productForm.is_active"
                    type="checkbox"
                    class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                  />
                  <span>Active</span>
                </label>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-zinc-900 mb-1" for="images">
                Image URLs
              </label>
              <textarea
                id="images"
                v-model="productForm.image_urls"
                rows="3"
                class="input font-mono"
                placeholder="Comma-separated URLs for product images"
              />
              <p class="mt-1 text-xs text-zinc-500">
                These URLs populate the gallery on the product page. First image is used as the primary thumbnail.
              </p>
            </div>

            <div class="flex items-center justify-end gap-3 pt-2">
              <button type="button" class="btn btn-secondary" @click="closeModal">
                Cancel
              </button>
              <button type="submit" class="btn btn-primary">
                {{ saving ? 'Saving…' : editingProduct ? 'Save changes' : 'Create product' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Plus, Search, Package, Edit2, Trash2, X } from 'lucide-vue-next'
import type { Database } from '~/types/database'

definePageMeta({
  middleware: 'admin'
})

type Product = Database['public']['Tables']['products']['Row']

const supabase = useSupabase()

const loading = ref(true)
const products = ref<Product[]>([])
const searchQuery = ref('')

const showModal = ref(false)
const saving = ref(false)
const editingProduct = ref<Product | null>(null)

const productForm = reactive({
  name: '',
  slug: '',
  sku: '',
  brand: '',
  price: null as number | null,
  stock_quantity: 0 as number | null,
  low_stock_threshold: 10 as number | null,
  is_featured: false,
  is_active: true,
  image_urls: ''
})

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

const resetProductForm = () => {
  productForm.name = ''
  productForm.slug = ''
  productForm.sku = ''
  productForm.brand = ''
  productForm.price = null
  productForm.stock_quantity = 0
  productForm.low_stock_threshold = 10
  productForm.is_featured = false
  productForm.is_active = true
  productForm.image_urls = ''
}

const openAddModal = () => {
  editingProduct.value = null
  resetProductForm()
  showModal.value = true
}

const openEditModal = (product: Product) => {
  editingProduct.value = product
  productForm.name = product.name
  productForm.slug = product.slug
  productForm.sku = product.sku
  productForm.brand = product.brand || ''
  productForm.price = product.price
  productForm.stock_quantity = product.stock_quantity
  productForm.low_stock_threshold = product.low_stock_threshold
  productForm.is_featured = product.is_featured
  productForm.is_active = product.is_active
  productForm.image_urls = (product.image_urls || []).join(', ')
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const saveProduct = async () => {
  if (!productForm.name || !productForm.slug || !productForm.sku || productForm.price === null) {
    return
  }

  saving.value = true

  try {
    const basePayload: Partial<Product> = {
      name: productForm.name,
      slug: productForm.slug,
      sku: productForm.sku,
      brand: productForm.brand || null,
      price: productForm.price ?? 0,
      stock_quantity: productForm.stock_quantity ?? 0,
      low_stock_threshold: productForm.low_stock_threshold ?? 10,
      is_featured: productForm.is_featured,
      is_active: productForm.is_active
    }

    if (productForm.image_urls.trim()) {
      ;(basePayload as any).image_urls = productForm.image_urls
        .split(',')
        .map((url) => url.trim())
        .filter(Boolean)
    }

    if (editingProduct.value) {
      const { error } = await supabase
        .from('products')
        .update(basePayload)
        .eq('id', editingProduct.value.id)

      if (error) throw error
    } else {
      const { error } = await supabase
        .from('products')
        .insert(basePayload)

      if (error) throw error
    }

    await fetchProducts()
    showModal.value = false
  } catch (error) {
    console.error('Error saving product:', error)
  } finally {
    saving.value = false
  }
}

const confirmDelete = async (product: Product) => {
  if (!window.confirm(`Delete product "${product.name}"?`)) return

  try {
    const { error } = await supabase.from('products').delete().eq('id', product.id)
    if (error) throw error
    await fetchProducts()
  } catch (error) {
    console.error('Error deleting product:', error)
  }
}

onMounted(() => {
  fetchProducts()
})

useHead({
  title: 'Manage Products - Admin - Flux',
  meta: [
    {
      name: 'description',
      content: 'Manage products in Flux'
    }
  ]
})
</script>
