<template>
  <div class="min-h-screen bg-[#FAFAFA]">
    <!-- Toast -->
    <Transition
      enter-active-class="transition-opacity duration-200"
      leave-active-class="transition-opacity duration-150"
      enter-from-class="opacity-0 translate-y-2"
      enter-to-class="opacity-100 translate-y-0"
      leave-from-class="opacity-100 translate-y-0"
      leave-to-class="opacity-0 translate-y-2"
    >
      <div
        v-if="toast.visible"
        class="fixed top-4 right-4 z-50 max-w-sm rounded-xl bg-zinc-900 text-zinc-50 shadow-xl border border-zinc-700/80 px-4 py-3 flex items-start gap-3"
      >
        <div class="mt-0.5 flex h-6 w-6 items-center justify-center rounded-full bg-emerald-500/10 text-emerald-400">
          <Check class="h-3.5 w-3.5" />
        </div>
        <div class="text-sm">
          <p class="font-medium">Item added successfully</p>
          <p class="mt-0.5 text-xs text-zinc-300">You can adjust quantity in your cart at any time.</p>
        </div>
      </div>
    </Transition>

    <!-- Main content -->
    <main class="pt-20 sm:pt-24 pb-28 md:pb-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Breadcrumbs -->
        <nav
          class="text-xs sm:text-sm text-zinc-500 mb-4 flex items-center flex-wrap gap-1"
          aria-label="Breadcrumb"
        >
          <NuxtLink to="/" class="hover:text-zinc-700">Home</NuxtLink>
          <span class="text-zinc-400">/</span>
          <NuxtLink to="/wines" class="hover:text-zinc-700">Drinks</NuxtLink>
          <span class="text-zinc-400">/</span>
          <NuxtLink to="/wines" class="hover:text-zinc-700">Wines</NuxtLink>
          <span class="text-zinc-400">/</span>
          <span class="hover:text-zinc-700">Red</span>
          <span class="text-zinc-400">/</span>
          <span class="text-zinc-700 font-medium line-clamp-1">{{ product.name }}</span>
        </nav>

        <!-- 2-column layout -->
        <section class="grid gap-8 lg:grid-cols-[minmax(0,1.15fr)_minmax(0,1fr)] lg:items-start">
          <!-- Gallery -->
          <div>
            <!-- Mobile gallery (swipe) -->
            <div class="md:hidden mb-4">
              <div class="relative rounded-2xl bg-white border border-zinc-200/80 overflow-hidden">
                <div class="aspect-[4/5] w-full flex items-center justify-center bg-zinc-50">
                  <img
                    :src="activeImage"
                    :alt="product.name"
                    class="h-full w-auto object-contain drop-shadow-xl"
                  />
                </div>

                <div class="absolute left-3 top-3 inline-flex items-center gap-1 rounded-full bg-black/55 px-2.5 py-1 text-[11px] font-medium text-zinc-50 backdrop-blur">
                  <ShieldCheck class="h-3.5 w-3.5 text-emerald-400" />
                  <span>100% authentic</span>
                </div>
              </div>

              <div class="mt-3 flex items-center gap-2 overflow-x-auto pb-1 -mx-1">
                <button
                  v-for="(image, index) in product.images"
                  :key="image + index"
                  type="button"
                  class="mx-1 h-16 w-16 flex-shrink-0 rounded-xl border transition-all overflow-hidden flex items-center justify-center bg-zinc-50"
                  :class="index === activeImageIndex ? 'border-[#D4AF37] ring-1 ring-[#D4AF37]' : 'border-zinc-200 hover:border-zinc-400'"
                  @click="setActiveImage(index)"
                >
                  <img :src="image" :alt="product.name" class="h-full w-auto object-contain" />
                </button>
              </div>
            </div>

            <!-- Desktop gallery -->
            <div class="hidden md:grid md:grid-cols-[80px_minmax(0,1fr)] gap-4 lg:gap-5">
              <!-- Thumbnails -->
              <div class="flex md:flex-col gap-2 md:gap-3">
                <button
                  v-for="(image, index) in product.images"
                  :key="image + index"
                  type="button"
                  class="h-16 w-16 lg:h-18 lg:w-18 flex items-center justify-center rounded-xl border bg-zinc-50 overflow-hidden transition-all"
                  :class="index === activeImageIndex ? 'border-[#D4AF37] ring-1 ring-[#D4AF37]' : 'border-zinc-200 hover:border-zinc-400'"
                  @click="setActiveImage(index)"
                >
                  <img :src="image" :alt="product.name" class="h-full w-auto object-contain" />
                </button>
              </div>

              <!-- Main image with hover zoom -->
              <div class="relative group rounded-2xl bg-white border border-zinc-200/80 overflow-hidden">
                <div class="relative aspect-[4/5] w-full bg-zinc-50 flex items-center justify-center">
                  <img
                    :src="activeImage"
                    :alt="product.name"
                    class="h-full w-auto object-contain transition-transform duration-300 group-hover:scale-105 drop-shadow-xl"
                  />
                </div>

                <!-- Zoom hint & authenticity badge -->
                <div class="pointer-events-none absolute inset-0 flex flex-col justify-between p-4">
                  <div class="flex justify-between">
                    <span class="inline-flex items-center gap-1 rounded-full bg-black/45 px-2.5 py-1 text-[11px] font-medium text-zinc-50 backdrop-blur">
                      <ShieldCheck class="h-3.5 w-3.5 text-emerald-400" />
                      <span>Official cellar partner</span>
                    </span>
                  </div>
                  <div class="flex justify-end">
                    <span class="inline-flex items-center gap-1 rounded-full bg-black/35 px-2 py-1 text-[11px] text-zinc-100 backdrop-blur">
                      <ZoomIn class="h-3.5 w-3.5" />
                      <span>Hover to zoom</span>
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Product info / buy box -->
          <aside class="space-y-4 lg:space-y-6">
            <div class="space-y-2">
              <button
                type="button"
                class="text-[11px] font-semibold uppercase tracking-[0.22em] text-zinc-500 hover:text-zinc-700"
              >
                {{ product.brand }}
              </button>
              <h1 class="font-serif text-2xl sm:text-3xl lg:text-4xl font-semibold text-[#282828] leading-tight">
                {{ product.name }}
              </h1>

              <!-- Ratings -->
              <div class="mt-1 flex flex-wrap items-center gap-2 text-xs text-zinc-600">
                <div class="flex items-center gap-0.5">
                  <Star
                    v-for="i in 5"
                    :key="i"
                    class="h-3.5 w-3.5"
                    :class="i <= Math.round(product.rating) ? 'text-[#D4AF37] fill-[#D4AF37]' : 'text-zinc-300'"
                  />
                </div>
                <span class="font-medium text-zinc-800">{{ product.rating.toFixed(1) }}</span>
                <span class="text-zinc-400">
                  ({{ product.ratingCount.toLocaleString() }} verified ratings)
                </span>
              </div>
            </div>

            <!-- Pricing & savings -->
            <div class="rounded-2xl bg-white border border-zinc-200/80 p-4 sm:p-5 space-y-3">
              <div class="flex items-baseline justify-between gap-4">
                <div>
                  <div class="flex items-baseline gap-2">
                    <p class="text-2xl sm:text-3xl font-semibold text-[#282828]">
                      ₦{{ product.price.toLocaleString() }}
                    </p>
                    <p
                      v-if="product.compareAtPrice && product.compareAtPrice > product.price"
                      class="text-sm text-zinc-400 line-through"
                    >
                      ₦{{ product.compareAtPrice.toLocaleString() }}
                    </p>
                  </div>
                  <p v-if="discountPercent" class="mt-1 inline-flex items-center gap-1 text-xs text-rose-600">
                    <span class="rounded-full bg-rose-50 px-2 py-0.5 font-semibold">
                      -{{ discountPercent }}%
                    </span>
                    <span>You save ₦{{ savingsAmount.toLocaleString() }}</span>
                  </p>
                </div>
              </div>

              <!-- Specs row -->
              <dl class="mt-3 grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
                <div class="flex items-center gap-2">
                  <div class="flex h-8 w-8 items-center justify-center rounded-full bg-zinc-100 text-zinc-700">
                    <Wine class="h-4 w-4" />
                  </div>
                  <div>
                    <dt class="text-[11px] uppercase tracking-[0.16em] text-zinc-400">Volume</dt>
                    <dd class="font-medium text-zinc-800">{{ product.volume }}</dd>
                  </div>
                </div>
                <div class="flex items-center gap-2">
                  <div class="flex h-8 w-8 items-center justify-center rounded-full bg-zinc-100 text-zinc-700">
                    <Droplets class="h-4 w-4" />
                  </div>
                  <div>
                    <dt class="text-[11px] uppercase tracking-[0.16em] text-zinc-400">ABV</dt>
                    <dd class="font-medium text-zinc-800">{{ product.abv }}</dd>
                  </div>
                </div>
                <div class="flex items-center gap-2">
                  <div class="flex h-8 w-8 items-center justify-center rounded-full bg-zinc-100 text-zinc-700">
                    <Calendar class="h-4 w-4" />
                  </div>
                  <div>
                    <dt class="text-[11px] uppercase tracking-[0.16em] text-zinc-400">Vintage</dt>
                    <dd class="font-medium text-zinc-800">{{ product.vintage }}</dd>
                  </div>
                </div>
                <div class="flex items-center gap-2">
                  <div class="flex h-8 w-8 items-center justify-center rounded-full bg-zinc-100 text-zinc-700">
                    <MapPin class="h-4 w-4" />
                  </div>
                  <div>
                    <dt class="text-[11px] uppercase tracking-[0.16em] text-zinc-400">Country</dt>
                    <dd class="font-medium text-zinc-800">{{ product.country }}</dd>
                  </div>
                </div>
              </dl>

              <!-- Quantity & actions -->
              <div class="mt-4 flex flex-col gap-3">
                <div class="inline-flex items-center gap-3">
                  <p class="text-xs font-medium text-zinc-600 uppercase tracking-[0.16em]">Quantity</p>
                  <div class="inline-flex items-center rounded-full border border-zinc-200 bg-zinc-50 px-1 text-sm">
                    <button
                      type="button"
                      class="flex h-8 w-8 items-center justify-center rounded-full text-zinc-700 hover:bg-zinc-100 disabled:opacity-40"
                      @click="decrementQuantity"
                      :disabled="quantity <= 1"
                    >
                      <Minus class="h-4 w-4" />
                    </button>
                    <span class="w-8 text-center font-medium text-zinc-900">{{ quantity }}</span>
                    <button
                      type="button"
                      class="flex h-8 w-8 items-center justify-center rounded-full text-zinc-700 hover:bg-zinc-100"
                      @click="incrementQuantity"
                    >
                      <Plus class="h-4 w-4" />
                    </button>
                  </div>
                </div>

                <div class="flex flex-col gap-2 mt-1">
                  <button
                    type="button"
                    class="hidden md:inline-flex w-full items-center justify-center rounded-full bg-[#D4AF37] px-6 py-3 text-sm font-semibold text-[#282828] shadow-[0_18px_40px_-24px_rgba(0,0,0,0.9)] hover:bg-[#caa430] transition-colors"
                    @click="handleAddToCart"
                  >
                    Add to cart
                  </button>
                  <button
                    type="button"
                    class="hidden md:inline-flex w-full items-center justify-center rounded-full bg-[#282828] px-6 py-3 text-sm font-semibold text-[#FAFAFA] hover:bg-black transition-colors"
                    @click="handleBuyNow"
                  >
                    Buy now
                  </button>
                </div>

                <div class="flex items-center justify-between mt-1">
                  <button
                    type="button"
                    class="inline-flex items-center gap-1.5 text-xs font-medium text-zinc-600 hover:text-zinc-900"
                    @click="toggleWishlistForProduct"
                  >
                    <Heart
                      class="h-4 w-4"
                      :class="isWishlisted ? 'fill-[#D4AF37] text-[#D4AF37]' : ''"
                    />
                    <span>{{ isWishlisted ? 'In wishlist' : 'Add to wishlist' }}</span>
                  </button>
                  <p class="text-[11px] text-zinc-500 flex items-center gap-1">
                    <Info class="h-3.5 w-3.5" />
                    <span>Safe &amp; temperature-aware delivery</span>
                  </p>
                </div>
              </div>
            </div>

            <!-- Delivery widget -->
            <div class="rounded-2xl bg-white border border-zinc-200/80 p-4 sm:p-5 space-y-3">
              <div class="flex items-start justify-between gap-3">
                <div class="flex items-start gap-2">
                  <div class="mt-0.5 flex h-8 w-8 items-center justify-center rounded-full bg-zinc-100 text-zinc-700">
                    <Truck class="h-4 w-4" />
                  </div>
                  <div class="text-sm">
                    <p class="font-medium text-zinc-900 flex items-center gap-1">
                      Deliver to
                      <button type="button" class="inline-flex items-center gap-1 text-xs font-semibold text-[#282828]">
                        Lagos, Nigeria
                        <ChevronDown class="h-3 w-3" />
                      </button>
                    </p>
                    <p class="mt-0.5 text-xs text-zinc-600">
                      Estimated delivery between <span class="font-medium">{{ estimatedDateRange }}</span>.
                    </p>
                  </div>
                </div>
              </div>

              <div class="flex flex-wrap items-center gap-3 text-[11px] text-zinc-600">
                <span class="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-1 text-emerald-700 border border-emerald-100">
                  <Sparkles class="h-3.5 w-3.5" />
                  <span>Insured, breakage-protected shipping</span>
                </span>
                <span class="inline-flex items-center gap-1 rounded-full bg-zinc-50 px-2 py-1 border border-zinc-200">
                  <Undo2 class="h-3.5 w-3.5" />
                  <span>Returns accepted within 7 days</span>
                </span>
              </div>
            </div>
          </aside>
        </section>

        <!-- Tabs -->
        <section class="mt-10 lg:mt-12">
          <div class="border-b border-zinc-200 flex items-center gap-4 text-sm overflow-x-auto">
            <button
              type="button"
              class="px-2 pb-3 border-b-2 -mb-px whitespace-nowrap"
              :class="activeTab === 'details' ? 'border-[#D4AF37] text-[#282828] font-semibold' : 'border-transparent text-zinc-500 hover:text-zinc-800'"
              @click="activeTab = 'details'"
            >
              Product details
            </button>
            <button
              type="button"
              class="px-2 pb-3 border-b-2 -mb-px whitespace-nowrap"
              :class="activeTab === 'specs' ? 'border-[#D4AF37] text-[#282828] font-semibold' : 'border-transparent text-zinc-500 hover:text-zinc-800'"
              @click="activeTab = 'specs'"
            >
              Specifications
            </button>
            <button
              type="button"
              class="px-2 pb-3 border-b-2 -mb-px whitespace-nowrap"
              :class="activeTab === 'reviews' ? 'border-[#D4AF37] text-[#282828] font-semibold' : 'border-transparent text-zinc-500 hover:text-zinc-800'"
              @click="activeTab = 'reviews'"
            >
              Customer reviews
            </button>
          </div>

          <!-- Details tab -->
          <div v-if="activeTab === 'details'" class="mt-6 grid gap-8 lg:grid-cols-[minmax(0,1.2fr)_minmax(0,0.9fr)]">
            <div class="space-y-4 text-sm text-zinc-700">
              <p>{{ product.description }}</p>

              <div class="grid sm:grid-cols-3 gap-4 mt-4">
                <div class="rounded-2xl bg-white border border-zinc-200/80 p-4">
                  <h3 class="text-xs font-semibold uppercase tracking-[0.18em] text-zinc-500 mb-2">Nose</h3>
                  <p class="text-sm text-zinc-700">{{ product.tastingNotes.nose }}</p>
                </div>
                <div class="rounded-2xl bg-white border border-zinc-200/80 p-4">
                  <h3 class="text-xs font-semibold uppercase tracking-[0.18em] text-zinc-500 mb-2">Palate</h3>
                  <p class="text-sm text-zinc-700">{{ product.tastingNotes.palate }}</p>
                </div>
                <div class="rounded-2xl bg-white border border-zinc-200/80 p-4">
                  <h3 class="text-xs font-semibold uppercase tracking-[0.18em] text-zinc-500 mb-2">Finish</h3>
                  <p class="text-sm text-zinc-700">{{ product.tastingNotes.finish }}</p>
                </div>
              </div>

              <div class="mt-4">
                <h3 class="text-xs font-semibold uppercase tracking-[0.18em] text-zinc-500 mb-2">
                  Food pairing
                </h3>
                <div class="flex flex-wrap items-center gap-2">
                  <span
                    v-for="pairing in product.foodPairing"
                    :key="pairing"
                    class="inline-flex items-center rounded-full bg-zinc-50 px-3 py-1 text-xs font-medium text-zinc-700 border border-zinc-200/80"
                  >
                    {{ pairing }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Rating summary -->
            <div class="rounded-2xl bg-white border border-zinc-200/80 p-4 sm:p-5 space-y-4">
              <div class="flex items-center gap-3">
                <div class="flex items-center justify-center h-12 w-12 rounded-full bg-amber-50 text-[#D4AF37]">
                  <Star class="h-6 w-6 fill-[#D4AF37]" />
                </div>
                <div>
                  <p class="text-sm font-semibold text-zinc-900">Customer rating</p>
                  <p class="text-xs text-zinc-600">
                    {{ product.rating.toFixed(1) }} out of 5 • {{ product.ratingCount.toLocaleString() }} reviews
                  </p>
                </div>
              </div>

              <div class="space-y-2 text-xs">
                <div
                  v-for="row in ratingBreakdown"
                  :key="row.stars"
                  class="flex items-center gap-2"
                >
                  <span class="w-10 text-right text-zinc-500">{{ row.stars }}★</span>
                  <div class="flex-1 h-2 rounded-full bg-zinc-100 overflow-hidden">
                    <div
                      class="h-full rounded-full bg-[#D4AF37]"
                      :style="{ width: row.percent + '%' }"
                    />
                  </div>
                  <span class="w-10 text-right text-zinc-500">{{ row.percent }}%</span>
                </div>
              </div>

              <p class="mt-1 text-[11px] text-zinc-500">
                Reviews are from verified orders fulfilled through our temperature-aware logistics partners.
              </p>
            </div>
          </div>

          <!-- Specs tab -->
          <div v-else-if="activeTab === 'specs'" class="mt-6 rounded-2xl bg-white border border-zinc-200/80 p-4 sm:p-6">
            <dl class="grid grid-cols-1 sm:grid-cols-2 gap-x-8 gap-y-3 text-sm">
              <div class="flex justify-between border-b border-zinc-100 py-2">
                <dt class="text-zinc-500">Grape varieties</dt>
                <dd class="font-medium text-zinc-800">Cabernet Sauvignon, Shiraz</dd>
              </div>
              <div class="flex justify-between border-b border-zinc-100 py-2">
                <dt class="text-zinc-500">Region</dt>
                <dd class="font-medium text-zinc-800">South Australia</dd>
              </div>
              <div class="flex justify-between border-b border-zinc-100 py-2">
                <dt class="text-zinc-500">Closure</dt>
                <dd class="font-medium text-zinc-800">Cork</dd>
              </div>
              <div class="flex justify-between border-b border-zinc-100 py-2">
                <dt class="text-zinc-500">Allergens</dt>
                <dd class="font-medium text-zinc-800">Contains sulfites</dd>
              </div>
            </dl>
          </div>

          <!-- Reviews tab -->
          <div v-else class="mt-6 rounded-2xl bg-white border border-zinc-200/80 p-4 sm:p-6 text-sm text-zinc-600">
            <p>Customer reviews integration will go here. For now, this is a placeholder section.</p>
          </div>
        </section>

        <!-- Customers also bought -->
        <section class="mt-10 lg:mt-14 pb-4">
          <div class="flex items-center justify-between gap-3 mb-4">
            <div>
              <h2 class="font-serif text-xl sm:text-2xl font-semibold text-[#282828]">Customers also bought</h2>
              <p class="text-xs sm:text-sm text-zinc-500">Curated picks frequently ordered with this bottle.</p>
            </div>
          </div>

          <div class="overflow-x-auto pb-2 -mx-1">
            <div class="flex gap-3 sm:gap-4 px-1">
              <article
                v-for="related in relatedProducts"
                :key="related.id"
                class="min-w-[58%] xs:min-w-[45%] sm:min-w-[32%] lg:min-w-[23%] max-w-xs rounded-xl border border-zinc-200/80 bg-white shadow-sm hover:shadow-md transition-all flex flex-col overflow-hidden"
              >
                <div class="relative bg-zinc-50 flex items-center justify-center px-3 pt-4 pb-2">
                  <div class="w-full aspect-[3/5] flex items-center justify-center">
                    <img
                      :src="related.images[0]"
                      :alt="related.name"
                      class="h-full w-auto object-contain drop-shadow-sm"
                    />
                  </div>
                </div>
                <div class="flex-1 p-3 flex flex-col gap-1.5">
                  <p class="text-[10px] font-semibold uppercase tracking-[0.18em] text-zinc-500">
                    {{ related.brand }}
                  </p>
                  <h3 class="text-xs sm:text-sm font-medium text-[#282828] line-clamp-2 min-h-[2.25rem]">
                    {{ related.name }}
                  </h3>
                  <div class="flex items-baseline gap-1 mt-1">
                    <span class="text-sm font-semibold text-[#282828]">
                      ₦{{ related.price.toLocaleString() }}
                    </span>
                    <span
                      v-if="related.compareAtPrice && related.compareAtPrice > related.price"
                      class="text-[11px] text-zinc-400 line-through"
                    >
                      ₦{{ related.compareAtPrice.toLocaleString() }}
                    </span>
                  </div>
                  <button
                    type="button"
                    class="mt-2 inline-flex items-center justify-center rounded-full border border-[#D4AF37] px-3 py-1.5 text-[11px] font-semibold text-[#D4AF37] hover:bg-[#D4AF37] hover:text-[#282828] transition-colors"
                  >
                    View details
                  </button>
                </div>
              </article>
            </div>
          </div>
        </section>
      </div>
    </main>

    <!-- Mobile sticky footer CTA -->
    <div class="fixed inset-x-0 bottom-0 z-50 border-t border-zinc-200 bg-white/95 backdrop-blur md:hidden">
      <div class="max-w-7xl mx-auto px-4 py-2.5 flex items-center justify-between gap-3">
        <div>
          <p class="text-[11px] uppercase tracking-[0.16em] text-zinc-500">Total</p>
          <p class="text-base font-semibold text-[#282828]">
            ₦{{ (product.price * quantity).toLocaleString() }}
          </p>
        </div>
        <button
          type="button"
          class="flex-1 inline-flex items-center justify-center rounded-full bg-[#D4AF37] px-4 py-2.5 text-sm font-semibold text-[#282828] shadow-[0_18px_40px_-24px_rgba(0,0,0,0.9)] hover:bg-[#caa430] transition-colors"
          @click="handleAddToCart"
        >
          Add to cart
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute } from '#imports'
import type { Database } from '~/types/database'
import {
  Calendar,
  Check,
  ChevronDown,
  Droplets,
  Heart,
  Info,
  MapPin,
  Minus,
  Plus,
  ShieldCheck,
  Sparkles,
  Star,
  Truck,
  Undo2,
  Wine,
  ZoomIn
} from 'lucide-vue-next'

type ProductRow = Database['public']['Tables']['products']['Row']
type Review = Database['public']['Tables']['reviews']['Row']

interface ProductDetail {
  id: string
  name: string
  brand: string
  price: number
  compareAtPrice?: number
  rating: number
  ratingCount: number
  volume: string
  abv: string
  vintage: string
  country: string
  description: string
  tastingNotes: {
    nose: string
    palate: string
    finish: string
  }
  foodPairing: string[]
  images: string[]
}

const route = useRoute()
const supabase = useSupabase()
const { addToCart } = useCart()
const { wishlistIds, toggleWishlist } = useWishlist()

const baseProduct: ProductDetail = {
  id: 'placeholder',
  name: 'Penfolds Bin 389 Cabernet Shiraz 2018',
  brand: 'Penfolds',
  price: 87000,
  compareAtPrice: 95000,
  rating: 4.8,
  ratingCount: 126,
  volume: '75cl',
  abv: '14.5%',
  vintage: '2018',
  country: 'Australia',
  description:
    'Often referred to as "Baby Grange", Penfolds Bin 389 marries the structure of Cabernet Sauvignon with the richness of Shiraz in a generous, cellar-worthy blend.',
  tastingNotes: {
    nose: 'Blackcurrant, dark cherry and mulberry layered with mocha, cedar and subtle mint.',
    palate: 'Full-bodied with ripe tannins, dark chocolate, plum and blackberry framed by fine oak spice.',
    finish: 'Long, savoury and persistent with lingering dark fruit, cocoa and gentle char.'
  },
  foodPairing: ['Ribeye steak', 'Aged cheddar', 'Lamb chops', 'Mushroom ragù'],
  images: [
    '/landing-page/wines.jpg',
    '/landing-page/glass-with-ice-cube-smoke.jpg',
    '/landing-page/wines 3.jpg'
  ]
}

const relatedProducts: ProductDetail[] = [
  baseProduct,
  {
    id: 'penfolds-bin-28',
    name: 'Penfolds Bin 28 Kalimna Shiraz',
    brand: 'Penfolds',
    price: 52000,
    compareAtPrice: 58000,
    rating: 4.6,
    ratingCount: 84,
    volume: '75cl',
    abv: '14%',
    vintage: '2019',
    country: 'Australia',
    description: '',
    tastingNotes: {
      nose: '',
      palate: '',
      finish: ''
    },
    foodPairing: [],
    images: ['/landing-page/wines.jpg']
  },
  {
    id: 'cloudy-bay-sauvignon',
    name: 'Cloudy Bay Sauvignon Blanc 2022',
    brand: 'Cloudy Bay',
    price: 42000,
    compareAtPrice: 46000,
    rating: 4.5,
    ratingCount: 67,
    volume: '75cl',
    abv: '13%',
    vintage: '2022',
    country: 'New Zealand',
    description: '',
    tastingNotes: {
      nose: '',
      palate: '',
      finish: ''
    },
    foodPairing: [],
    images: ['/landing-page/glass-with-ice-cube-smoke.jpg']
  }
]

const product = ref<ProductDetail>(baseProduct)

const hydrateFromRow = (row: ProductRow, rating: number, ratingCount: number) => {
  // Preserve existing storytelling fields but hydrate commerce data from Supabase
  product.value = {
    ...product.value,
    id: row.id,
    name: row.name,
    brand: row.brand || product.value.brand,
    price: row.price,
    compareAtPrice: row.compare_at_price ?? product.value.compareAtPrice,
    volume: row.volume || product.value.volume,
    abv: row.alcohol_percentage != null ? `${row.alcohol_percentage}%` : product.value.abv,
    country: row.country_of_origin || product.value.country,
    description:
      row.description || row.short_description || product.value.description,
    images:
      Array.isArray(row.image_urls) && row.image_urls.length
        ? row.image_urls
        : product.value.images,
    rating: ratingCount ? rating : product.value.rating,
    ratingCount: ratingCount || product.value.ratingCount,
    tastingNotes: product.value.tastingNotes,
    foodPairing: product.value.foodPairing
  }
}

const fetchProductFromSupabase = async () => {
  try {
    const slug = route.params.slug as string | undefined
    if (!slug) return

    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('slug', slug)
      .eq('is_active', true)
      .maybeSingle<ProductRow>()

    if (error || !data) {
      console.error('Error fetching product detail:', error)
      return
    }

    let rating = 0
    let ratingCount = 0

    const { data: reviewsData, error: reviewsError } = await supabase
      .from('reviews')
      .select('rating')
      .eq('product_id', data.id)

    if (!reviewsError && reviewsData && reviewsData.length) {
      ratingCount = reviewsData.length
      rating = (reviewsData as Review[]).reduce((sum, r) => sum + r.rating, 0) / ratingCount
    }

    hydrateFromRow(data, rating, ratingCount)
  } catch (err) {
    console.error('Error fetching product detail:', err)
  }
}

onMounted(() => {
  fetchProductFromSupabase()
})

watch(
  () => route.params.slug,
  () => {
    fetchProductFromSupabase()
  }
)

const activeImageIndex = ref(0)
const activeImage = computed(() => product.value.images[activeImageIndex.value] || product.value.images[0])

const setActiveImage = (index: number) => {
  if (index < 0 || index >= product.value.images.length) return
  activeImageIndex.value = index
}

const quantity = ref(1)

const incrementQuantity = () => {
  quantity.value += 1
}

const decrementQuantity = () => {
  if (quantity.value > 1) quantity.value -= 1
}

const discountPercent = computed(() => {
  if (!product.value.compareAtPrice || product.value.compareAtPrice <= product.value.price) return null
  return Math.round(((product.value.compareAtPrice - product.value.price) / product.value.compareAtPrice) * 100)
})

const savingsAmount = computed(() => {
  if (!product.value.compareAtPrice || product.value.compareAtPrice <= product.value.price) return 0
  return product.value.compareAtPrice - product.value.price
})

const estimatedDateRange = computed(() => {
  const today = new Date()
  const start = new Date(today)
  const end = new Date(today)
  start.setDate(today.getDate() + 2)
  end.setDate(today.getDate() + 4)
  const format = (d: Date) => d.toLocaleDateString('en-NG', { month: 'short', day: 'numeric' })
  return `${format(start)}  ${format(end)}`
})

const activeTab = ref<'details' | 'specs' | 'reviews'>('details')

const ratingBreakdown = computed(() => {
  return [
    { stars: 5, percent: 72 },
    { stars: 4, percent: 20 },
    { stars: 3, percent: 5 },
    { stars: 2, percent: 2 },
    { stars: 1, percent: 1 }
  ]
})

const toast = ref({ visible: false })
let toastTimeout: ReturnType<typeof setTimeout> | null = null

const showToast = () => {
  toast.value.visible = true
  if (toastTimeout) clearTimeout(toastTimeout)
  toastTimeout = setTimeout(() => {
    toast.value.visible = false
  }, 2200)
}

const isWishlisted = computed(() => {
  const id = product.value?.id
  if (!id) return false
  return wishlistIds.value.includes(String(id))
})

const toggleWishlistForProduct = () => {
  const id = product.value?.id
  if (!id) return
  toggleWishlist(String(id))
}

const handleAddToCart = async () => {
  if (!product.value?.id) return

  try {
    const result = await addToCart(product.value.id, quantity.value)
    if (result.success) {
      showToast()
    } else {
      console.error('Failed to add to cart:', result.error)
    }
  } catch (err) {
    console.error('Error adding to cart:', err)
  }
}

const handleBuyNow = async () => {
  if (!product.value?.id) return

  try {
    const result = await addToCart(product.value.id, quantity.value)
    if (result.success) {
      await navigateTo('/checkout')
    } else {
      console.error('Failed to add to cart for buy now:', result.error)
    }
  } catch (err) {
    console.error('Error in buy now:', err)
  }
}
</script>
