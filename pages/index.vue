<template>
  <div class="bg-white">
    <!-- Hero Carousel -->
    <section
      class="relative overflow-hidden bg-black text-white"
    >
      <div
        class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col lg:flex-row items-center gap-10 lg:gap-16 py-16 lg:py-24"
      >
        <!-- Carousel Visual -->
        <div
          class="relative w-full lg:w-1/2 h-[320px] sm:h-[420px] lg:h-[520px] rounded-3xl overflow-hidden"
          @mouseenter="isCarouselPaused = true"
          @mouseleave="isCarouselPaused = false"
        >
          <div
            class="absolute inset-0 bg-gradient-to-tr from-black/70 via-black/30 to-transparent z-10"
            aria-hidden="true"
          ></div>

          <div
            class="relative h-full w-full"
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
              <div class="flex justify-end p-4">
                <span
                  class="inline-flex items-center gap-2 rounded-full bg-black/40 px-3 py-1 text-xs font-medium tracking-wide backdrop-blur"
                >
                  <span class="inline-block h-2 w-2 rounded-full bg-emerald-400"></span>
                  Curated cellar moments
                </span>
              </div>

              <div class="flex items-end justify-between p-4">
                <div class="flex gap-2" aria-hidden="true">
                  <button
                    v-for="(slide, index) in heroSlides"
                    :key="slide.id"
                    type="button"
                    class="h-1.5 w-6 rounded-full transition-all duration-200"
                    :class="index === activeSlide ? 'bg-white' : 'bg-white/40 hover:bg-white/80'"
                    @click="goToSlide(index)"
                  />
                </div>

                <div class="flex items-center gap-2">
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
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Hero Copy -->
        <div
          class="relative w-full lg:w-1/2 text-left text-zinc-50"
        >
          <div
            class="absolute -inset-4 -z-10 rounded-3xl bg-gradient-to-tr from-amber-500/10 via-rose-500/5 to-transparent blur-3xl"
            aria-hidden="true"
          ></div>

          <p class="mb-4 inline-flex items-center gap-2 rounded-full bg-white/5 px-3 py-1 text-xs font-semibold uppercase tracking-[0.2em] text-amber-100">
            Fine Wine E‑Commerce
          </p>

          <h1 class="font-serif text-4xl sm:text-5xl lg:text-6xl font-semibold leading-tight text-white mb-4">
            Cellar‑worthy bottles,
            <span class="text-amber-200">delivered to your door.</span>
          </h1>

          <p class="max-w-xl text-base sm:text-lg text-zinc-200 leading-relaxed mb-6">
            Discover hand‑picked reds, whites, and sparkling icons from the world’s most
            celebrated regions. Every bottle is stored, handled, and shipped with
            sommelier‑level care.
          </p>

          <div class="flex flex-wrap items-center gap-4 mb-6">
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
        </div>
      </div>
    </section>

    <!-- Catalog preview -->
    <section class="py-16 sm:py-20 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4 mb-10">
          <div>
            <h2 class="font-serif text-3xl sm:text-4xl font-semibold text-zinc-900 mb-2">
              Cellar‑ready bestsellers
            </h2>
            <p class="text-sm sm:text-base text-zinc-600 max-w-xl">
              A rotating selection of bottles our community reorders again and again. Limited
              allocations update weekly.
            </p>
          </div>
          <NuxtLink
            to="/products"
            class="text-sm font-medium text-zinc-900 hover:text-zinc-600 underline underline-offset-4"
          >
            View full catalog
          </NuxtLink>
        </div>

        <div v-if="loadingProducts" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <div
            v-for="i in 4"
            :key="i"
            class="card animate-pulse"
          >
            <div class="aspect-[3/4] bg-zinc-100 rounded-xl mb-4"></div>
            <div class="h-4 bg-zinc-200 rounded mb-2"></div>
            <div class="h-3 bg-zinc-200 rounded w-2/3 mb-2"></div>
            <div class="h-3 bg-zinc-100 rounded w-1/3"></div>
          </div>
        </div>

        <div
          v-else-if="featuredProducts.length > 0"
          class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6"
        >
          <article
            v-for="product in featuredProducts"
            :key="product.id"
            class="group card flex flex-col h-full"
          >
            <div class="relative mb-4">
              <div class="aspect-[3/4] w-full overflow-hidden rounded-xl bg-zinc-100">
                <img
                  v-if="product.image_urls?.[0]"
                  :src="product.image_urls[0]"
                  :alt="product.name"
                  class="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
                />
                <div
                  v-else
                  class="flex h-full w-full items-center justify-center text-zinc-300"
                >
                  <Wine :size="48" />
                </div>
              </div>

              <div
                v-if="product.averageRating && product.reviewCount"
                class="absolute left-3 top-3 inline-flex items-center gap-1 rounded-full bg-black/70 px-2.5 py-1 text-xs font-medium text-amber-100 backdrop-blur"
              >
                <Star :size="14" class="fill-amber-300 text-amber-300" />
                <span>{{ product.averageRating.toFixed(1) }}</span>
                <span class="text-[11px] text-zinc-200/80">
                  ({{ product.reviewCount }})
                </span>
              </div>
            </div>

            <div class="flex flex-1 flex-col gap-2">
              <div>
                <h3 class="text-sm sm:text-base font-semibold text-zinc-900 line-clamp-2 mb-1">
                  {{ product.name }}
                </h3>
                <p class="text-xs text-zinc-600">
                  {{ product.country_of_origin || 'From renowned wine regions worldwide' }}
                </p>
              </div>

              <div class="mt-1 flex items-baseline justify-between gap-2">
                <p class="text-base font-semibold text-zinc-900">
                  ${{ product.price.toFixed(2) }}
                </p>
                <p
                  v-if="product.compare_at_price && product.compare_at_price > product.price"
                  class="text-xs text-zinc-500 line-through"
                >
                  ${{ product.compare_at_price.toFixed(2) }}
                </p>
              </div>

              <div class="mt-4 flex items-center gap-2">
                <button
                  type="button"
                  class="btn btn-secondary w-full justify-center text-xs sm:text-sm"
                  @click="openQuickView(product)"
                >
                  Quick view
                </button>
                <NuxtLink
                  :to="`/products/${product.slug}`"
                  class="btn btn-outline w-full justify-center text-xs sm:text-sm"
                >
                  View product
                </NuxtLink>
              </div>
            </div>
          </article>
        </div>

        <div v-else class="text-center py-12">
          <p class="text-zinc-600 mb-4">
            Our debut vintages are being prepared for release. Check back soon for featured bottles.
          </p>
          <NuxtLink to="/products" class="btn btn-primary">
            Browse all wines
          </NuxtLink>
        </div>
      </div>
    </section>

    <!-- Explore by category -->
    <section class="py-12 sm:py-16 bg-zinc-50 border-y border-zinc-100">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
          <div>
            <h2 class="font-serif text-2xl sm:text-3xl font-semibold text-zinc-900 mb-1">
              Explore wines by category
            </h2>
            <p class="text-sm text-zinc-600 max-w-xl">
              Follow your favourite styles or discover new regions with one tap.
            </p>
          </div>
        </div>

        <div class="flex flex-wrap gap-3">
          <button
            v-for="category in wineCategories"
            :key="category.label"
            type="button"
            class="inline-flex items-center gap-2 rounded-full border border-zinc-200 bg-white px-4 py-2 text-xs sm:text-sm font-medium text-zinc-800 shadow-sm hover:border-zinc-300 hover:bg-zinc-50 focus:outline-none focus:ring-2 focus:ring-zinc-900"
            @click="goToCategory(category)"
          >
            <span
              class="flex h-6 w-6 items-center justify-center rounded-full bg-zinc-900 text-[11px] text-zinc-50"
            >
              {{ category.abbr }}
            </span>
            <span>{{ category.label }}</span>
          </button>
        </div>
      </div>
    </section>

    <!-- Value propositions -->
    <section class="py-14 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
          <div class="flex items-start gap-4">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-zinc-900 text-white">
              <Truck :size="18" />
            </div>
            <div>
              <h3 class="text-sm font-semibold text-zinc-900 mb-1">
                Free shipping over ${{ freeShippingThreshold.toFixed(0) }}
              </h3>
              <p class="text-sm text-zinc-600">
                Carefully packed, insured shipments with optional temperature‑controlled delivery
                in select regions.
              </p>
            </div>
          </div>

          <div class="flex items-start gap-4">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-zinc-900 text-white">
              <ShieldCheck :size="18" />
            </div>
            <div>
              <h3 class="text-sm font-semibold text-zinc-900 mb-1">
                Authenticity guaranteed
              </h3>
              <p class="text-sm text-zinc-600">
                Direct allocations and vetted partners only. Provenance tracked from cellar to
                your collection.
              </p>
            </div>
          </div>

          <div class="flex items-start gap-4">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-zinc-900 text-white">
              <CreditCard :size="18" />
            </div>
            <div>
              <h3 class="text-sm font-semibold text-zinc-900 mb-1">
                Secure, flexible payments
              </h3>
              <p class="text-sm text-zinc-600">
                Encrypted checkout with cards, bank transfers, and local payment options where
                available.
              </p>
            </div>
          </div>

          <div class="flex items-start gap-4">
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-zinc-900 text-white">
              <Sparkles :size="18" />
            </div>
            <div>
              <h3 class="text-sm font-semibold text-zinc-900 mb-1">
                Expert sommelier picks
              </h3>
              <p class="text-sm text-zinc-600">
                Seasonal selections and verticals curated for both weekday glasses and blue‑chip
                cellaring.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Blog teaser & testimonials -->
    <section class="py-16 sm:py-20 bg-zinc-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col gap-12 lg:gap-16">
        <!-- Blog teaser -->
        <div>
          <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4 mb-6">
            <div>
              <h2 class="font-serif text-2xl sm:text-3xl font-semibold text-zinc-900 mb-1">
                From the tasting room journal
              </h2>
              <p class="text-sm text-zinc-600 max-w-xl">
                Short, practical guides from our sommeliers on building a collection you’ll
                actually drink.
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <article
              v-for="post in blogTeasers"
              :key="post.id"
              class="group h-full overflow-hidden rounded-2xl border border-zinc-200 bg-white shadow-sm transition-transform duration-200 hover:-translate-y-0.5 hover:shadow-md"
            >
              <div class="aspect-[4/3] overflow-hidden bg-zinc-100">
                <img
                  :src="post.imageUrl"
                  :alt="post.title"
                  class="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
                />
              </div>
              <div class="p-4 sm:p-5 flex flex-col gap-2">
                <p class="text-xs text-zinc-500 uppercase tracking-[0.18em]">
                  {{ post.tagline }}
                </p>
                <h3 class="text-sm sm:text-base font-semibold text-zinc-900 line-clamp-2">
                  {{ post.title }}
                </h3>
                <p class="text-xs text-zinc-600 line-clamp-2">
                  {{ post.summary }}
                </p>
              </div>
            </article>
          </div>
        </div>

        <!-- Testimonials preview -->
        <div id="testimonials" class="border-t border-zinc-200 pt-10">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
            <h2 class="font-serif text-2xl sm:text-3xl font-semibold text-zinc-900">
              Trusted by collectors & hospitality teams
            </h2>
            <a
              href="#testimonials"
              class="text-sm font-medium text-zinc-900 hover:text-zinc-600 underline underline-offset-4"
            >
              Read more testimonials
            </a>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <figure
              v-for="testimonial in testimonials"
              :key="testimonial.name"
              class="relative overflow-hidden rounded-2xl border border-zinc-200 bg-white p-6 sm:p-8"
            >
              <Quote class="absolute -top-3 -left-3 h-10 w-10 text-zinc-100" />
              <blockquote class="relative text-sm text-zinc-700 leading-relaxed mb-4">
                “{{ testimonial.quote }}”
              </blockquote>
              <figcaption class="relative text-sm font-medium text-zinc-900">
                {{ testimonial.name }}
                <span class="block text-xs font-normal text-zinc-500">
                  {{ testimonial.role }}
                </span>
              </figcaption>
            </figure>
          </div>
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
import { ArrowLeft, ArrowRight, CreditCard, Quote, ShieldCheck, Sparkles, Star, Truck, Wine, X } from 'lucide-vue-next'
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']
type Review = Database['public']['Tables']['reviews']['Row']

type ProductWithRating = Product & {
  averageRating?: number
  reviewCount?: number
}

const supabase = useSupabase()

// Hero carousel
const heroSlides = [
  {
    id: 1,
    imageUrl: '/landing-page/glass-with-ice-cube-smoke.jpg',
    alt: 'Dimly lit wine cellar with rows of bottles resting in oak racks.'
  },
  {
    id: 2,
    imageUrl: '/landing-page/glass-with-ice-cube-smoke.jpg',
    alt: 'Elegant tablescape with crystal stemware and a decanted red wine.'
  },
  {
    id: 3,
    imageUrl: '/landing-page/glass-with-ice-cube-smoke.jpg',
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

// Catalog preview
const loadingProducts = ref(true)
const featuredProducts = ref<ProductWithRating[]>([])
const freeShippingThreshold = ref(200)

const fetchFeaturedProducts = async () => {
  loadingProducts.value = true
  try {
    const { data: productsData, error: productsError } = await supabase
      .from('products')
      .select('*')
      .eq('is_active', true)
      .eq('is_featured', true)
      .order('created_at', { ascending: false })
      .limit(8)

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
  fetchFeaturedProducts()
})

onBeforeUnmount(() => {
  stopAutoplay()
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
