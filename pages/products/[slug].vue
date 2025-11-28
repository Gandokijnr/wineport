<template>
  <div v-if="loading" class="min-h-screen bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="animate-pulse">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
          <div class="aspect-square bg-zinc-200 rounded-lg"></div>
          <div class="space-y-4">
            <div class="h-8 bg-zinc-200 rounded w-3/4"></div>
            <div class="h-4 bg-zinc-200 rounded w-1/2"></div>
            <div class="h-12 bg-zinc-200 rounded w-1/4"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div v-else-if="product" class="min-h-screen bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <nav class="flex items-center gap-2 text-sm text-zinc-600 mb-8">
        <NuxtLink to="/products" class="hover:text-zinc-900">Products</NuxtLink>
        <ChevronRight :size="16" />
        <span class="text-zinc-900">{{ product.name }}</span>
      </nav>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 mb-16">
        <div>
          <div class="aspect-square bg-zinc-100 rounded-xl overflow-hidden mb-4">
            <img
              v-if="mainImage"
              :src="mainImage"
              :alt="product.name"
              class="w-full h-full object-cover"
            />
            <div v-else class="w-full h-full flex items-center justify-center">
              <Wine :size="96" class="text-zinc-300" />
            </div>
          </div>

          <div v-if="product.image_urls.length > 1" class="grid grid-cols-4 gap-2">
            <button
              v-for="(image, index) in product.image_urls"
              :key="index"
              @click="mainImage = image"
              class="aspect-square bg-zinc-100 rounded-lg overflow-hidden border-2 transition-colors"
              :class="mainImage === image ? 'border-zinc-900' : 'border-transparent hover:border-zinc-300'"
            >
              <img :src="image" :alt="`${product.name} ${index + 1}`" class="w-full h-full object-cover" />
            </button>
          </div>
        </div>

        <div class="space-y-6">
          <div>
            <h1 class="text-4xl font-bold text-zinc-900 mb-2">{{ product.name }}</h1>
            <p v-if="product.brand" class="text-lg text-zinc-600">{{ product.brand }}</p>
          </div>

          <div class="flex items-baseline gap-3">
            <span class="text-3xl font-bold text-zinc-900">${{ product.price.toFixed(2) }}</span>
            <span
              v-if="product.compare_at_price && product.compare_at_price > product.price"
              class="text-xl text-zinc-500 line-through"
            >
              ${{ product.compare_at_price.toFixed(2) }}
            </span>
          </div>

          <div class="flex items-center gap-4 text-sm">
            <div v-if="product.volume" class="flex items-center gap-2">
              <span class="text-zinc-600">Volume:</span>
              <span class="font-medium text-zinc-900">{{ product.volume }}</span>
            </div>
            <div v-if="product.alcohol_percentage" class="flex items-center gap-2">
              <span class="text-zinc-600">ABV:</span>
              <span class="font-medium text-zinc-900">{{ product.alcohol_percentage }}%</span>
            </div>
          </div>

          <div v-if="product.stock_quantity > 0" class="space-y-4">
            <div class="flex items-center gap-4">
              <label class="text-sm font-medium text-zinc-900">Quantity:</label>
              <div class="flex items-center border border-zinc-300 rounded-lg">
                <button
                  @click="decrementQuantity"
                  class="px-4 py-2 hover:bg-zinc-50 transition-colors"
                  :disabled="quantity <= 1"
                >
                  <Minus :size="16" />
                </button>
                <input
                  v-model.number="quantity"
                  type="number"
                  min="1"
                  :max="product.stock_quantity"
                  class="w-16 text-center border-x border-zinc-300 py-2 focus:outline-none"
                />
                <button
                  @click="incrementQuantity"
                  class="px-4 py-2 hover:bg-zinc-50 transition-colors"
                  :disabled="quantity >= product.stock_quantity"
                >
                  <Plus :size="16" />
                </button>
              </div>
            </div>

            <button
              @click="addToCart"
              :disabled="addingToCart"
              class="btn btn-primary w-full py-3 text-base disabled:opacity-50"
            >
              <span v-if="!addingToCart">Add to Cart</span>
              <span v-else>Adding...</span>
            </button>
          </div>

          <div v-else class="p-4 bg-red-50 border border-red-200 rounded-lg">
            <p class="text-red-800 font-medium">Out of Stock</p>
            <p class="text-sm text-red-600 mt-1">This product is currently unavailable</p>
          </div>

          <div v-if="product.stock_quantity <= product.low_stock_threshold && product.stock_quantity > 0">
            <div class="flex items-center gap-2 text-orange-600 text-sm">
              <AlertCircle :size="16" />
              <span>Only {{ product.stock_quantity }} left in stock</span>
            </div>
          </div>

          <div class="pt-6 border-t border-zinc-200 space-y-3">
            <div v-if="product.country_of_origin" class="flex items-start gap-3">
              <span class="text-sm text-zinc-600 w-32">Origin:</span>
              <span class="text-sm text-zinc-900 font-medium">{{ product.country_of_origin }}</span>
            </div>
            <div class="flex items-start gap-3">
              <span class="text-sm text-zinc-600 w-32">SKU:</span>
              <span class="text-sm text-zinc-900 font-mono">{{ product.sku }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-3xl">
        <h2 class="text-2xl font-bold text-zinc-900 mb-4">Product Description</h2>
        <div v-if="product.description" class="text-zinc-700 leading-relaxed whitespace-pre-line">
          {{ product.description }}
        </div>
        <p v-else class="text-zinc-600 italic">No description available.</p>
      </div>
    </div>
  </div>

  <div v-else class="min-h-screen bg-white flex items-center justify-center">
    <div class="text-center">
      <h1 class="text-2xl font-bold text-zinc-900 mb-2">Product Not Found</h1>
      <p class="text-zinc-600 mb-6">The product you're looking for doesn't exist.</p>
      <NuxtLink to="/products" class="btn btn-primary">
        Browse Products
      </NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronRight, Wine, Minus, Plus, AlertCircle } from 'lucide-vue-next'
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']

const route = useRoute()
const supabase = useSupabase()

const loading = ref(true)
const product = ref<Product | null>(null)
const mainImage = ref<string | null>(null)
const quantity = ref(1)
const addingToCart = ref(false)

const fetchProduct = async () => {
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('slug', route.params.slug)
      .eq('is_active', true)
      .maybeSingle()

    if (error) throw error

    product.value = data
    if (data && data.image_urls.length > 0) {
      mainImage.value = data.image_urls[0]
    }
  } catch (error) {
    console.error('Error fetching product:', error)
  } finally {
    loading.value = false
  }
}

const incrementQuantity = () => {
  if (product.value && quantity.value < product.value.stock_quantity) {
    quantity.value++
  }
}

const decrementQuantity = () => {
  if (quantity.value > 1) {
    quantity.value--
  }
}

const cart = useCart()

const addToCart = async () => {
  if (!product.value) return

  addingToCart.value = true

  const result = await cart.addToCart(product.value.id, quantity.value)

  if (result.success) {
    await cart.fetchCart()
  } else {
    console.error('Failed to add to cart:', result.error)
  }

  addingToCart.value = false
}

onMounted(() => {
  fetchProduct()
})

watch(() => route.params.slug, () => {
  fetchProduct()
})

watchEffect(() => {
  if (product.value) {
    useHead({
      title: `${product.value.name} - LiquidLogistics`,
      meta: [
        {
          name: 'description',
          content: product.value.short_description || product.value.description || `Buy ${product.value.name} from LiquidLogistics`
        }
      ]
    })
  }
})
</script>
