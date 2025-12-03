<template>
  <div class="min-h-screen bg-[#FAFAFA]">
    <main class="pt-20 sm:pt-24 pb-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between gap-3 mb-6">
          <div>
            <h1 class="font-serif text-2xl sm:text-3xl font-semibold text-[#282828]">
              Your wishlist
            </h1>
            <p class="mt-1 text-sm text-zinc-500">
              {{ wishlistCountText }}
            </p>
          </div>
        </div>

        <div v-if="loading" class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 lg:gap-4 mt-2">
          <div
            v-for="n in 8"
            :key="n"
            class="rounded-xl bg-white border border-zinc-200/80 p-3 sm:p-4 flex flex-col gap-3 shimmer"
          >
            <div class="rounded-lg bg-zinc-100/80 h-32 sm:h-40"></div>
            <div class="space-y-2">
              <div class="h-2.5 w-16 rounded-full bg-zinc-100"></div>
              <div class="h-3 w-32 rounded-full bg-zinc-100"></div>
              <div class="flex gap-2 mt-1">
                <div class="h-5 w-12 rounded-full bg-zinc-100"></div>
                <div class="h-5 w-10 rounded-full bg-zinc-100"></div>
              </div>
            </div>
            <div class="mt-auto space-y-1">
              <div class="h-3 w-20 rounded-full bg-zinc-100"></div>
              <div class="h-3 w-16 rounded-full bg-zinc-100"></div>
            </div>
          </div>
        </div>

        <div
          v-else-if="products.length"
          class="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 lg:gap-4"
        >
          <WineCard
            v-for="product in products"
            :key="product.id"
            :product="mapProductToCardProduct(product)"
            @addToCart="() => handleAddToCart(product)"
          />
        </div>

        <div v-else class="mt-10 flex flex-col items-center justify-center text-center text-sm text-zinc-500">
          <p class="text-base font-medium text-zinc-700 mb-1">Your wishlist is empty</p>
          <p class="max-w-md mb-4">
            Tap the heart icon on any bottle you love, and it will appear here for easy access.
          </p>
          <NuxtLink
            to="/products"
            class="inline-flex items-center justify-center rounded-full bg-[#D4AF37] px-5 py-2.5 text-sm font-semibold text-[#282828] hover:bg-[#c39c30]"
          >
            Browse products
          </NuxtLink>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import WineCard from '~/components/WineCard.vue'
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']

const supabase = useSupabase()
const { addToCart } = useCart()
const { wishlistIds } = useWishlist()

const products = ref<Product[]>([])
const loading = ref(true)
const addingToCartId = ref<string | null>(null)

const wishlistCountText = computed(() => {
  const count = wishlistIds.value.length
  if (!count) return 'No items saved yet.'
  if (count === 1) return '1 item saved for later.'
  return `${count} items saved for later.`
})

const fetchWishlistProducts = async () => {
  loading.value = true
  try {
    const ids = wishlistIds.value
    if (!ids.length) {
      products.value = []
      return
    }

    const { data, error } = await supabase
      .from('products')
      .select('*')
      .in('id', ids)
      .eq('is_active', true)

    if (error) throw error

    products.value = (data || []) as Product[]
  } catch (err) {
    console.error('Error fetching wishlist products:', err)
    products.value = []
  } finally {
    loading.value = false
  }
}

const getTypeLabel = (product: Product): string => {
  const tags = (product.tags || []).map(tag => tag.toLowerCase())
  const name = product.name.toLowerCase()

  if (tags.includes('red') || name.includes('red wine')) return 'Red'
  if (tags.includes('white') || name.includes('white wine')) return 'White'
  if (tags.some(t => t.includes('rosé') || t.includes('rose')) || name.includes('rosé')) return 'Rosé'
  if (tags.includes('sparkling') || tags.includes('champagne') || name.includes('champagne')) return 'Sparkling'

  return 'Red'
}

const mapProductToCardProduct = (product: Product) => {
  return {
    id: product.id,
    slug: product.slug,
    name: product.name,
    brand: product.brand || 'Cellar Selection',
    price: product.price,
    oldPrice: product.compare_at_price ?? undefined,
    image: Array.isArray(product.image_urls) && product.image_urls.length
      ? product.image_urls[0]
      : '/landing-page/glass-with-ice-cube-smoke.jpg',
    badges: product.is_featured ? ['Featured'] : undefined,
    rating: undefined,
    specs: {
      type: getTypeLabel(product),
      abv: product.alcohol_percentage != null ? `${product.alcohol_percentage}%` : undefined
    }
  }
}

const handleAddToCart = async (product: Product) => {
  if (!product.id) return
  addingToCartId.value = product.id
  const { success } = await addToCart(product.id, 1)
  if (!success) {
    console.error('Failed to add product to cart from wishlist')
  }
  addingToCartId.value = null
}

onMounted(() => {
  fetchWishlistProducts()
})

watch(
  wishlistIds,
  () => {
    fetchWishlistProducts()
  },
  { deep: true }
)

useHead({
  title: 'Wishlist - Flux'
})
</script>

<style scoped>
.shimmer {
  position: relative;
  overflow: hidden;
}

.shimmer::after {
  content: '';
  position: absolute;
  inset: 0;
  transform: translateX(-100%);
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.7), transparent);
  animation: shimmer 1.4s infinite;
}

@keyframes shimmer {
  100% {
    transform: translateX(100%);
  }
}
</style>
