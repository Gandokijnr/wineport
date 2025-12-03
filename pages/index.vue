<template>
  <div class="bg-white">
    <section
      class="relative overflow-hidden bg-[#282828] text-white"
    >
      <div
        class="relative w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 lg:py-12"
      >
        <div class="grid lg:grid-cols-[260px_minmax(0,1.6fr)_minmax(0,1fr)] gap-6 lg:gap-8 items-stretch">
          <aside class="hidden lg:block">
            <div class="bg-white/5 rounded-2xl p-3 space-y-1">
              <button
                v-for="category in wineCategories"
                :key="category.label"
                type="button"
                class="flex w-full items-center justify-between gap-2 rounded-xl px-3 py-2 text-sm font-medium text-zinc-50/90 hover:bg-white/10 hover:text-white transition-colors"
                @click="goToCategory(category)"
              >
                <span class="flex items-center gap-2">
                  <span class="flex h-7 w-7 items-center justify-center rounded-full bg-white/10 text-[11px] text-zinc-50">
                    {{ category.abbr }}
                  </span>
                  <span class="truncate">{{ category.label }}</span>
                </span>
                <span class="text-xs text-zinc-300">›</span>
              </button>
            </div>
          </aside>

          <div class="flex flex-col items-center gap-10 lg:gap-16">
            <div
              class="relative w-full rounded-3xl overflow-hidden"
              @mouseenter="isCarouselPaused = true"
              @mouseleave="isCarouselPaused = false"
            >
              <div
                class="absolute inset-0 bg-gradient-to-tr from-black/70 via-black/30 to-transparent z-10"
                aria-hidden="true"
              ></div>

              <div
                class="relative h-[420px] sm:h-[480px] lg:h-[560px] w-full"
                role="region"
                aria-label="Featured wine experiences"
                tabindex="0"
                @focusin="isCarouselPaused = true"
                @focusout="isCarouselPaused = false"
                @keydown.left.prevent="previousSlide"
                @keydown.right.prevent="nextSlide"
              >
                <div
                  v-for="(slide, index) in heroSlides"
                  :key="slide.id"
                  class="absolute inset-0 transition-opacity duration-700 ease-out"
                  :class="index === activeSlide ? 'opacity-100' : 'opacity-0 pointer-events-none'"
                  :aria-hidden="index !== activeSlide"
                >
                  <img
                    :src="slide.imageUrl"
                    :alt="slide.alt"
                    class="h-full w-full object-cover"
                  />
                </div>

                <!-- Carousel controls -->
                <div class="absolute inset-0 flex flex-col justify-between z-20">
                  <!-- <div class="flex justify-end p-4">
                    <span
                      class="inline-flex items-center gap-2 rounded-full bg-black/40 px-3 py-1 text-xs font-medium tracking-wide backdrop-blur"
                    >
                      <span class="inline-block h-2 w-2 rounded-full bg-emerald-400"></span>
                      Curated cellar moments
                    </span>
                  </div> -->

                  <div class="flex items-end justify-between p-4">
                    <!-- <div class="flex gap-2" aria-hidden="true">
                      <button
                        v-for="(slide, index) in heroSlides"
                        :key="slide.id"
                        type="button"
                        class="h-1.5 w-6 rounded-full transition-all duration-200"
                        :class="index === activeSlide ? 'bg-white' : 'bg-white/40 hover:bg-white/80'"
                        @click="goToSlide(index)"
                      />
                    </div> -->

                    <!-- <div class="flex items-center gap-2">
                      <button
                        type="button"
                        class="flex h-9 w-9 items-center justify-center rounded-full bg-black/40 text-white hover:bg-black/70 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-black focus:ring-white"
                        @click="previousSlide"
                        aria-label="Previous slide"
                      >
                        <ArrowLeft :size="18" />
                      </button>
                      <button
                        type="button"
                        class="flex h-9 w-9 items-center justify-center rounded-full bg-black/40 text-white hover:bg-black/70 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-black focus:ring-white"
                        @click="nextSlide"
                        aria-label="Next slide"
                      >
                        <ArrowRight :size="18" />
                      </button>
                    </div> -->
                  </div>
                </div>

                <!-- Hero content overlay -->
                <div class="absolute inset-0 z-30 flex items-center backdrop-blur-sm">
                  <div class="w-full px-4 sm:px-6 lg:px-8">
                    <div class="relative max-w-xl text-left text-zinc-50">
                      <div
                        class="absolute -inset-4 -z-10 rounded-3xl bg-gradient-to-tr from-amber-500/10 via-rose-500/5 to-transparent blur-3xl"
                        aria-hidden="true"
                      ></div>

                      <div class="hidden flex-wrap items-center gap-4 mb-6 md:flex">
                        <NuxtLink
                          to="/products?featured=true"
                          class="btn btn-primary px-6 sm:px-8 py-3 text-sm sm:text-base"
                        >
                          Shop Bestsellers
                        </NuxtLink>
                        <NuxtLink
                          to="/products"
                          class="btn btn-secondary px-6 sm:px-8 py-3 text-sm sm:text-base"
                        >
                          Explore Collections
                        </NuxtLink>
                      </div>

                      <div class="flex flex-wrap items-center gap-6 text-xs sm:text-sm text-zinc-200/90">
                        <div class="flex items-center gap-2">
                          <Sparkles :size="16" />
                          <span>Curated by in‑house sommeliers</span>
                        </div>
                        <div class="flex items-center gap-2">
                          <ShieldCheck :size="16" />
                          <span>Temperature‑aware fulfillment partners</span>
                        </div>
                      </div>

                      <div class="mt-6 md:grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div class="rounded-2xl bg-white/5 px-4 py-3 flex items-center gap-3">
                          <div class="flex h-10 w-10 items-center justify-center rounded-full bg-[#D4AF37] text-[#282828]">
                            <Sparkles :size="18" />
                          </div>
                          <div class="text-xs sm:text-sm">
                            <p class="font-semibold">New cellar arrivals</p>
                            <p class="text-zinc-200/80">Shop this weeks allocations before they sell out.</p>
                          </div>
                        </div>
                        <div class="rounded-2xl bg-white/5 px-4 py-3 flex items-center gap-3">
                          <div class="flex h-10 w-10 items-center justify-center rounded-full bg-white/10 text-[#D4AF37]">
                            <CreditCard :size="18" />
                          </div>
                          <div class="text-xs sm:text-sm">
                            <p class="font-semibold">Flexible payments</p>
                            <p class="text-zinc-200/80">Secure checkout with cards and local methods.</p>
                          </div>
                        </div>
                        <div class="sm:col-span-2 rounded-2xl bg-[#FAFAFA]/95 text-[#282828] px-4 py-4 flex items-center justify-between gap-4">
                          <div class="flex items-center gap-3">
                            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-[#282828] text-[#D4AF37]">
                              <Headset :size="18" />
                            </div>
                            <div class="text-xs sm:text-sm">
                              <p class="font-semibold">Prefer to order by phone?</p>
                              <p class="text-zinc-600">Our sommeliers can place your order in minutes.</p>
                            </div>
                          </div>
                          <button
                            type="button"
                            class="inline-flex items-center gap-2 rounded-full bg-[#282828] text-[#FAFAFA] px-4 py-2 text-xs sm:text-sm font-semibold hover:bg-black transition-colors"
                          >
                            <PhoneCall :size="16" />
                            <span>Call to order</span>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="mt-6 flex gap-4 overflow-x-auto pb-1 lg:mt-0 lg:flex-col lg:overflow-visible lg:pb-0">
            <div class="min-w-[260px] lg:min-w-0 rounded-3xl bg-gradient-to-br from-[#D4AF37] via-[#f7e7b9] to-[#D4AF37] p-4 shadow-lg flex flex-col justify-between lg:h-[240px]">
              <div class="text-[11px] font-semibold uppercase tracking-[0.2em] text-[#5b430f]/80">
                Cellar festival
              </div>
              <div>
                <p class="text-2xl sm:text-3xl font-bold text-[#282828] leading-tight">
                  Up to 20% OFF
                </p>
                <p class="mt-1 text-xs sm:text-sm text-[#4b3a16]">
                  Curated cellar cases and gift-ready duos for every celebration.
                </p>
              </div>
              <div class="mt-3 inline-flex items-center gap-1 rounded-full bg-[#282828] text-[#FAFAFA] px-3 py-1 text-[11px] font-semibold animate-pulse">
                Limited time · Shop festival
              </div>
            </div>

            <div class="min-w-[260px] lg:min-w-0 rounded-3xl bg-[#141414]/90 border border-white/10 p-4 shadow-lg flex flex-col justify-between lg:h-[240px]">
              <div class="flex items-center gap-2">
                <div class="flex h-9 w-9 items-center justify-center rounded-full bg-[#D4AF37]/15 text-[#D4AF37]">
                  <Sparkles :size="18" />
                </div>
                <p class="text-[11px] font-semibold uppercase tracking-[0.2em] text-zinc-300">
                  Sign up & save
                </p>
              </div>
              <div class="mt-2">
                <p class="text-sm sm:text-base font-semibold text-white">
                  Extra 10% off your first cellar order
                </p>
                <p class="mt-1 text-xs text-zinc-400">
                  Join our list for member-only releases and early access drops.
                </p>
              </div>
              <button
                type="button"
                class="mt-3 inline-flex items-center gap-2 rounded-full bg-[#FAFAFA] text-[#282828] px-4 py-2 text-xs font-semibold group hover:bg-[#D4AF37] hover:text-[#282828] transition-colors"
              >
                <span>Unlock welcome offer</span>
                <ArrowRight :size="14" class="transition-transform group-hover:translate-x-1" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Flash Sales -->
    <section class="py-6 sm:py-8 bg-[#282828] text-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <div>
            <h2 class="font-serif text-2xl sm:text-3xl font-semibold">Flash Sales</h2>
            <p class="text-xs sm:text-sm text-zinc-300 max-w-md">
              Limited-time offers on cellar-worthy bottles. Once they're gone, they're gone.
            </p>
          </div>
          <div class="flex items-center gap-2 text-xs sm:text-sm">
            <span class="uppercase tracking-[0.18em] text-zinc-400">Ends in</span>
            <span class="inline-flex items-center gap-1 rounded-full bg-black/40 px-3 py-1 font-mono text-sm">
              <span>{{ flashCountdown }}</span>
            </span>
          </div>
        </div>

        <div
          v-if="flashSaleProducts.length > 0"
          class="mt-4 sm:mt-6 overflow-x-auto pb-2"
        >
          <div
            class="grid grid-flow-col auto-cols-[68%] xs:auto-cols-[55%] sm:auto-cols-[40%] md:auto-cols-[30%] lg:auto-cols-[23%] gap-4"
          >
            <WineCard
              v-for="product in flashSaleProducts"
              :key="product.id"
              :product="mapProductToCardProduct(product)"
              @addToCart="() => handleAddToCart(product)"
            />
          </div>
        </div>
      </div>
    </section>

    <!-- All wines preview -->
    <section class="py-10 bg-[#FAFAFA]">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <div>
            <h2 class="font-serif text-2xl sm:text-3xl font-semibold text-[#282828]">All wines</h2>
            <p class="text-xs sm:text-sm text-zinc-500 max-w-md">
              Explore more bottles from our cellar. This is a preview of today's selection.
            </p>
          </div>
        </div>

        <div v-if="loadingProducts" class="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 lg:gap-4">
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
          v-else-if="featuredProducts.length"
          class="mt-4 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 lg:gap-4"
        >
          <WineCard
            v-for="product in featuredProducts"
            :key="product.id"
            :product="mapProductToCardProduct(product)"
            @addToCart="() => handleAddToCart(product)"
          />
        </div>

        <div v-else class="mt-6 text-sm text-zinc-500">
          No wines are available right now. Please check back soon.
        </div>

        <div class="mt-6 flex justify-center">
          <NuxtLink
            to="/products"
            class="inline-flex items-center justify-center rounded-full border border-[#D4AF37] px-6 py-2.5 text-sm font-semibold text-[#D4AF37] hover:bg-[#D4AF37] hover:text-[#282828] transition-colors"
          >
            View all wines
          </NuxtLink>
        </div>
      </div>
    </section>

    <!-- Subscribe CTA -->
    <section class="py-12 bg-zinc-900 text-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-center">
          <div class="lg:col-span-2">
            <h2 class="font-serif text-2xl sm:text-3xl font-semibold mb-3">
              Subscribe for cellar‑door releases and private allocations.
            </h2>
            <p class="text-sm sm:text-base text-zinc-300 max-w-xl">
              Be first in line for limited drops, vertical releases, and sommelier‑only tasting
              notes—no spam, ever.
            </p>
          </div>

          <form
            class="flex flex-col sm:flex-row gap-3"
            @submit.prevent
          >
            <label class="sr-only" for="landing-email">
              Email address
            </label>
            <input
              id="landing-email"
              v-model="subscribeEmail"
              type="email"
              required
              autocomplete="email"
              placeholder="you@example.com"
              class="input bg-white text-zinc-900 placeholder:text-zinc-400"
            />
            <button
              type="submit"
              class="btn btn-primary w-full sm:w-auto px-6 py-3 text-sm sm:text-base"
            >
              Get early access
            </button>
          </form>
        </div>
      </div>
    </section>

    <!-- Quick view modal -->
    <Transition
      enter-active-class="transition-opacity duration-150"
      leave-active-class="transition-opacity duration-150"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="quickViewProduct"
        class="fixed inset-0 z-40 flex items-center justify-center bg-black/40 px-4 sm:px-6 lg:px-8"
        role="dialog"
        aria-modal="true"
      >
        <div
          class="max-w-2xl w-full rounded-2xl bg-white shadow-2xl outline-none"
        >
          <div class="grid grid-cols-1 md:grid-cols-2 gap-0">
            <div class="relative h-64 md:h-full overflow-hidden rounded-t-2xl md:rounded-l-2xl md:rounded-tr-none bg-zinc-100">
              <img
                v-if="quickViewProduct.image_urls?.[0]"
                :src="quickViewProduct.image_urls[0]"
                :alt="quickViewProduct.name"
                class="h-full w-full object-cover"
              />
              <div
                v-else
                class="flex h-full w-full items-center justify-center text-zinc-300"
              >
                <Wine :size="56" />
              </div>
            </div>

            <div class="flex flex-col gap-3 p-6 sm:p-7">
              <div class="flex items-start justify-between gap-4">
                <div>
                  <h3 class="font-serif text-xl font-semibold text-zinc-900 mb-1">
                    {{ quickViewProduct.name }}
                  </h3>
                  <p
                    v-if="quickViewProduct.country_of_origin"
                    class="text-sm text-zinc-600"
                  >
                    {{ quickViewProduct.country_of_origin }}
                  </p>
                </div>
                <button
                  type="button"
                  class="rounded-full p-1.5 text-zinc-500 hover:bg-zinc-100 hover:text-zinc-900 focus:outline-none focus:ring-2 focus:ring-zinc-900"
                  @click="closeQuickView"
                  aria-label="Close quick view"
                >
                  <X :size="18" />
                </button>
              </div>

              <div class="flex items-center gap-3 text-sm">
                <p class="text-lg font-semibold text-zinc-900">
                  ${{ quickViewProduct.price.toFixed(2) }}
                </p>
                <p
                  v-if="quickViewProduct.compare_at_price && quickViewProduct.compare_at_price > quickViewProduct.price"
                  class="text-xs text-zinc-500 line-through"
                >
                  ${{ quickViewProduct.compare_at_price.toFixed(2) }}
                </p>
                <div
                  v-if="quickViewProduct.averageRating && quickViewProduct.reviewCount"
                  class="flex items-center gap-1 text-xs text-zinc-700"
                >
                  <Star :size="14" class="fill-amber-300 text-amber-300" />
                  <span>{{ quickViewProduct.averageRating.toFixed(1) }}</span>
                  <span class="text-zinc-400">·</span>
                  <span>{{ quickViewProduct.reviewCount }} reviews</span>
                </div>
              </div>

              <p class="text-sm text-zinc-700 line-clamp-4">
                {{ quickViewProduct.short_description || quickViewProduct.description || 'A carefully selected wine from our curated collection.' }}
              </p>

              <div class="mt-4 flex flex-col sm:flex-row gap-3">
                <NuxtLink
                  :to="`/products/${quickViewProduct.slug}`"
                  class="btn btn-primary w-full justify-center text-sm"
                  @click="closeQuickView"
                >
                  View full details
                </NuxtLink>
                <NuxtLink
                  to="/products"
                  class="btn btn-secondary w-full justify-center text-sm"
                  @click="closeQuickView"
                >
                  Continue browsing
                </NuxtLink>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeft, ArrowRight, CreditCard, PhoneCall, Headset, Quote, ShieldCheck, Sparkles, Star, Truck, Wine, X } from 'lucide-vue-next'
import WineCard from '~/components/WineCard.vue'
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']
type Review = Database['public']['Tables']['reviews']['Row']

type ProductWithRating = Product & {
  averageRating?: number
  reviewCount?: number
}

const supabase = useSupabase()
const { addToCart } = useCart()

const getTypeLabel = (product: ProductWithRating): string => {
  const tags = (product.tags || []).map(tag => tag.toLowerCase())
  const name = product.name.toLowerCase()

  if (tags.includes('red') || name.includes('red wine')) return 'Red'
  if (tags.includes('white') || name.includes('white wine')) return 'White'
  if (tags.some(t => t.includes('rosé') || t.includes('rose')) || name.includes('rosé')) return 'Rosé'
  if (tags.includes('sparkling') || tags.includes('champagne') || name.includes('champagne')) return 'Sparkling'

  return 'Red'
}

const getBrandLabel = (product: ProductWithRating): string => {
  return product.brand || 'Cellar Selection'
}

const mapProductToCardProduct = (product: ProductWithRating) => {
  return {
    id: product.id,
    slug: product.slug,
    name: product.name,
    brand: getBrandLabel(product),
    price: product.price,
    oldPrice: product.compare_at_price ?? undefined,
    image: Array.isArray(product.image_urls) && product.image_urls.length
      ? product.image_urls[0]
      : '/landing-page/glass-with-ice-cube-smoke.jpg',
    badges: product.is_featured ? ['Featured'] : undefined,
    rating: product.averageRating,
    specs: {
      type: getTypeLabel(product),
      abv: product.alcohol_percentage != null ? `${product.alcohol_percentage}%` : undefined
    }
  }
}

// Hero carousel
const heroSlides = [
  {
    id: 1,
    imageUrl: '/landing-page/glass-with-ice-cube-smoke.jpg',
    alt: 'Dimly lit wine cellar with rows of bottles resting in oak racks.'
  },
  {
    id: 2,
    imageUrl: '/landing-page/wines.jpg',
    alt: 'Elegant tablescape with crystal stemware and a decanted red wine.'
  },
  {
    id: 3,
    imageUrl: '/landing-page/wines 3.jpg',
    alt: 'Sunset over a hillside vineyard with golden light on the vines.'
  }
]

const activeSlide = ref(0)
const isCarouselPaused = ref(false)
let carouselTimer: ReturnType<typeof setInterval> | null = null

const goToSlide = (index: number) => {
  if (index < 0) {
    activeSlide.value = heroSlides.length - 1
  } else if (index >= heroSlides.length) {
    activeSlide.value = 0
  } else {
    activeSlide.value = index
  }
}

const nextSlide = () => {
  goToSlide(activeSlide.value + 1)
}

const previousSlide = () => {
  goToSlide(activeSlide.value - 1)
}

const startAutoplay = () => {
  if (carouselTimer) return
  carouselTimer = setInterval(() => {
    if (!isCarouselPaused.value) {
      nextSlide()
    }
  }, 7000)
}

const stopAutoplay = () => {
  if (carouselTimer) {
    clearInterval(carouselTimer)
    carouselTimer = null
  }
}

// Flash sales countdown (client-side only)
const flashCountdown = ref('02:00:00')
let flashEndTime: number | null = null
let flashInterval: ReturnType<typeof setInterval> | null = null

const updateFlashCountdown = () => {
  if (!flashEndTime) return
  const remaining = Math.max(0, flashEndTime - Date.now())
  const totalSeconds = Math.floor(remaining / 1000)
  const hours = String(Math.floor(totalSeconds / 3600)).padStart(2, '0')
  const minutes = String(Math.floor((totalSeconds % 3600) / 60)).padStart(2, '0')
  const seconds = String(totalSeconds % 60).padStart(2, '0')
  flashCountdown.value = `${hours}:${minutes}:${seconds}`
}

const startFlashCountdown = () => {
  if (flashInterval) return
  // Simple 2-hour window from first mount
  flashEndTime = Date.now() + 2 * 60 * 60 * 1000
  updateFlashCountdown()
  flashInterval = setInterval(updateFlashCountdown, 1000)
}

const stopFlashCountdown = () => {
  if (flashInterval) {
    clearInterval(flashInterval)
    flashInterval = null
  }
}

// Catalog preview
const loadingProducts = ref(true)
const featuredProducts = ref<ProductWithRating[]>([])
const freeShippingThreshold = ref(200)

const flashSaleProducts = computed(() => featuredProducts.value.slice(0, 8))

type DealsTab = 'flash' | 'top' | 'recommended'
const activeDealsTab = ref<DealsTab>('flash')

const setDealsTab = (tab: DealsTab) => {
  activeDealsTab.value = tab
}

const addingToCartId = ref<string | null>(null)

const handleAddToCart = async (product: ProductWithRating) => {
  if (!product.id) return
  addingToCartId.value = product.id
  const { success } = await addToCart(product.id, 1)
  if (!success) {
    console.error('Failed to add product to cart')
  }
  addingToCartId.value = null
}

const fetchFeaturedProducts = async () => {
  loadingProducts.value = true
  try {
    const { data: productsData, error: productsError } = await supabase
      .from('products')
      .select('*')
      .eq('is_active', true)
      // .eq('is_featured', true)
      .order('created_at', { ascending: false })
      .limit(20)

    if (productsError) throw productsError

    const baseProducts = (productsData || []) as Product[]
    const productIds = baseProducts.map(p => p.id)

    let enriched: ProductWithRating[] = baseProducts

    if (productIds.length > 0) {
      const { data: reviewsData, error: reviewsError } = await supabase
        .from('reviews')
        .select('product_id, rating')
        .in('product_id', productIds)

      if (reviewsError) throw reviewsError

      const ratingMap = new Map<string, { total: number; count: number }>()

      for (const review of (reviewsData || []) as Review[]) {
        const current = ratingMap.get(review.product_id) || { total: 0, count: 0 }
        current.total += review.rating
        current.count += 1
        ratingMap.set(review.product_id, current)
      }

      enriched = baseProducts.map(product => {
        const aggregate = ratingMap.get(product.id)
        return {
          ...product,
          averageRating: aggregate ? aggregate.total / aggregate.count : undefined,
          reviewCount: aggregate?.count
        }
      })
    }

    featuredProducts.value = enriched
  } catch (error) {
    console.error('Error fetching featured products:', error)
    featuredProducts.value = []
  } finally {
    loadingProducts.value = false
  }
}

// Quick view
const quickViewProduct = ref<ProductWithRating | null>(null)

const openQuickView = (product: ProductWithRating) => {
  quickViewProduct.value = product
  isCarouselPaused.value = true
}

const closeQuickView = () => {
  quickViewProduct.value = null
  isCarouselPaused.value = false
}

// Category chips
const wineCategories = [
  { label: 'Red', abbr: 'R', query: 'red' },
  { label: 'White', abbr: 'W', query: 'white' },
  { label: 'Sparkling', abbr: 'SP', query: 'sparkling' },
  { label: 'Rosé', abbr: 'RO', query: 'rose' },
  { label: 'Fortified', abbr: 'F', query: 'fortified' },
  { label: 'Organic & Biodynamic', abbr: 'OB', query: 'organic' },
  { label: 'By Region', abbr: 'RG', query: 'region' }
]

const goToCategory = (category: { query: string }) => {
  navigateTo(`/products?category=${encodeURIComponent(category.query)}`)
}

// Blog teaser (static for now)
const blogTeasers = [
  {
    id: 'cellar-basics',
    title: 'Building a weeknight‑friendly cellar without over‑spending',
    summary: 'How to balance everyday bottles with age‑worthy picks so your rack always has the right wine for the moment.',
    imageUrl: 'https://plus.unsplash.com/premium_photo-1682065727827-9f3c8bbbbd0f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d2luZXxlbnwwfDJ8MHx8fDA%3D',
    tagline: 'Cellar Notes'
  },
  {
    id: 'food-pairing',
    title: 'Pairing new‑world Pinot with modern comfort food',
    summary: 'From roasted chicken to mushroom risotto, discover textural pairings that make Pinot the hero.',
    imageUrl: 'https://images.unsplash.com/photo-1656235123277-9ac111857004?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHdpbmV8ZW58MHwyfDB8fHww',
    tagline: 'Pairing Guide'
  },
  {
    id: 'sparkling-service',
    title: 'Serving sparkling like a sommelier at home',
    summary: 'Glassware, temperature, and opening rituals that honour your grower Champagne and pet‑nat favorites.',
    imageUrl: 'https://images.unsplash.com/photo-1602215967218-817e91b4ca99?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8d2luZXxlbnwwfDJ8MHx8fDA%3D',
    tagline: 'Service Rituals'
  }
]

// Testimonials (static preview)
const testimonials = [
  {
    name: 'Isabelle M.',
    role: 'Private collector, London',
    quote: 'The curation feels like a conversation with a sommelier who actually remembers what I love.'
  },
  {
    name: 'Chef Daniel K.',
    role: 'Executive Chef, boutique hotel',
    quote: 'Their allocations and logistics have made our glass‑pour list both more interesting and more predictable.'
  }
]

// Subscribe CTA (local state only)
const subscribeEmail = ref('')

onMounted(() => {
  startAutoplay()
  startFlashCountdown()
  fetchFeaturedProducts()
})

onBeforeUnmount(() => {
  stopAutoplay()
  stopFlashCountdown()
})

useHead({
  title: 'Flux - Premium Wine E‑Commerce',
  meta: [
    {
      name: 'description',
      content: 'Discover cellar‑worthy wines, curated by sommeliers and delivered with temperature‑aware logistics.'
    }
  ]
})
</script>
