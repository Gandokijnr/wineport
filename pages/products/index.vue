<template>
  <div class="bg-[#FAFAFA] min-h-screen">
    <!-- Age gate overlay -->
    <Transition
      enter-active-class="transition-opacity duration-200"
      leave-active-class="transition-opacity duration-200"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="showAgeGate"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4 sm:px-6"
        role="dialog"
        aria-modal="true"
      >
        <div class="w-full max-w-md rounded-2xl bg-white shadow-2xl border border-zinc-200/80 p-6 sm:p-8">
          <h2 class="font-serif text-2xl font-semibold text-[#282828] mb-2">
            Wines & Spirits Access
          </h2>
          <p class="text-sm text-zinc-600 mb-4">
            You must be at least 18 years old to view and purchase wines and spirits.
          </p>
          <p class="text-sm text-zinc-500 mb-6">
            By confirming, you acknowledge that you meet the legal drinking age in your country.
          </p>
          <div class="flex flex-col sm:flex-row gap-3 sm:justify-end">
            <button
              type="button"
              class="inline-flex items-center justify-center rounded-full border border-zinc-300 px-4 py-2.5 text-sm font-medium text-zinc-700 hover:bg-zinc-50"
              @click="handleUnderAge"
            >
              I'm under 18
            </button>
            <button
              type="button"
              class="inline-flex items-center justify-center rounded-full bg-[#D4AF37] px-5 py-2.5 text-sm font-semibold text-[#282828] hover:bg-[#c39c30]"
              @click="confirmAge"
            >
              Yes, I'm 18+
            </button>
          </div>
        </div>
      </div>
    </Transition>

    <!-- Main content -->
    <section class="pt-20 pb-12 sm:pt-24 sm:pb-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Breadcrumbs -->
        <nav class="text-xs sm:text-sm text-zinc-500 mb-3 flex items-center flex-wrap gap-1" aria-label="Breadcrumb">
          <span class="hover:text-zinc-700 cursor-pointer">Home</span>
          <span class="text-zinc-400">/</span>
          <span class="hover:text-zinc-700 cursor-pointer">Drinks</span>
          <span class="text-zinc-400">/</span>
          <span class="hover:text-zinc-700 cursor-pointer">Wines</span>
          <span class="text-zinc-400">/</span>
          <span class="text-zinc-700 font-medium">{{ categoryMeta.breadcrumb }}</span>
        </nav>

        <!-- Header area -->
        <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between mb-4 sm:mb-6">
          <div>
            <h1 class="font-serif text-2xl sm:text-3xl md:text-4xl font-semibold text-[#282828] tracking-tight">
              {{ categoryMeta.title }}
            </h1>
            <p class="mt-1 text-xs sm:text-sm text-zinc-500">
              Showing <span class="font-medium text-zinc-700">{{ totalResults }}</span> curated bottles for your cellar and table.
            </p>
          </div>

          <div class="hidden sm:flex items-center gap-3 text-xs sm:text-sm text-zinc-500">
            <span class="inline-flex items-center gap-1 rounded-full bg-amber-50 border border-amber-100 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.18em] text-amber-700">
              <span class="h-1.5 w-1.5 rounded-full bg-[#D4AF37]"></span>
              Cellar-grade selection
            </span>
          </div>
        </div>

        <!-- Mobile filters bar -->
        <div class="lg:hidden sticky top-14 sm:top-16 z-30 -mx-4 sm:-mx-6 bg-[#FAFAFA]/95 backdrop-blur flex items-center justify-between px-4 sm:px-6 py-2 border-y border-zinc-100">
          <button
            type="button"
            class="inline-flex items-center gap-2 rounded-full border border-zinc-200 bg-white px-3 py-1.5 text-xs font-medium text-zinc-800 shadow-sm active:scale-[0.98]"
            @click="mobileFiltersOpen = true"
          >
            <Filter class="h-4 w-4 text-[#D4AF37]" />
            <span>Filters</span>
          </button>

          <div class="flex items-center gap-3 text-xs">
            <div class="flex items-center gap-2">
              <span class="text-zinc-500">Sort by</span>
              <button
                type="button"
                class="inline-flex items-center gap-1 rounded-full border border-zinc-200 bg-white px-3 py-1.5 text-xs font-medium text-zinc-800 shadow-sm"
              >
                <span>{{ sortLabel }}</span>
                <ChevronDown class="h-3.5 w-3.5 text-zinc-400" />
              </button>
            </div>
            <div class="flex items-center gap-1">
              <button
                type="button"
                class="inline-flex items-center justify-center rounded-full border px-2.5 py-1 text-[11px] font-medium"
                :class="viewMode === 'grid' ? 'border-[#D4AF37] bg-amber-50/50 text-[#282828]' : 'border-zinc-200 bg-white text-zinc-600'"
                @click="viewMode = 'grid'"
              >
                Grid
              </button>
              <button
                type="button"
                class="inline-flex items-center justify-center rounded-full border px-2.5 py-1 text-[11px] font-medium"
                :class="viewMode === 'list' ? 'border-[#D4AF37] bg-amber-50/50 text-[#282828]' : 'border-zinc-200 bg-white text-zinc-600'"
                @click="viewMode = 'list'"
              >
                List
              </button>
            </div>
          </div>
        </div>

        <div class="mt-4 grid grid-cols-1 lg:grid-cols-[280px_minmax(0,1fr)] gap-6 lg:gap-8 items-start">
          <!-- Sidebar filters (desktop) -->
          <aside class="hidden lg:block">
            <div class="sticky top-28 space-y-5">
              <div class="flex items-center justify-between mb-1">
                <h2 class="text-sm font-semibold text-[#282828] tracking-[0.16em] uppercase">
                  Filters
                </h2>
                <button
                  type="button"
                  class="text-xs text-zinc-500 hover:text-zinc-700"
                  @click="resetFilters"
                >
                  Clear all
                </button>
              </div>

              <div class="space-y-3 text-sm">
                <details open class="group rounded-xl border border-zinc-200/80 bg-white/70">
                  <summary class="flex cursor-pointer items-center justify-between px-4 py-3">
                    <span class="font-medium text-[#282828]">Price range</span>
                    <SlidersHorizontal class="h-4 w-4 text-zinc-400 group-open:rotate-90 transition-transform" />
                  </summary>
                  <div class="border-t border-zinc-100 px-4 py-3 space-y-3">
                    <div class="flex items-center gap-2 text-xs text-zinc-500">
                      <span>Min</span>
                      <input
                        v-model.number="filters.minPrice"
                        type="number"
                        min="0"
                        class="h-9 w-full rounded-lg border border-zinc-200 bg-zinc-50 px-2 text-xs focus:outline-none focus:ring-1 focus:ring-[#D4AF37]"
                        placeholder="0"
                      />
                      <span>Max</span>
                      <input
                        v-model.number="filters.maxPrice"
                        type="number"
                        min="0"
                        class="h-9 w-full rounded-lg border border-zinc-200 bg-zinc-50 px-2 text-xs focus:outline-none focus:ring-1 focus:ring-[#D4AF37]"
                        placeholder="50000"
                      />
                    </div>
                    <p class="text-[11px] text-zinc-400">Prices in NGN</p>
                  </div>
                </details>

                <details open class="group rounded-xl border border-zinc-200/80 bg-white/70">
                  <summary class="flex cursor-pointer items-center justify-between px-4 py-3">
                    <span class="font-medium text-[#282828]">Brand / Vineyard</span>
                    <ChevronDown class="h-4 w-4 text-zinc-400 group-open:rotate-180 transition-transform" />
                  </summary>
                  <div class="border-t border-zinc-100 px-4 py-3 space-y-3">
                    <div class="relative">
                      <input
                        v-model="brandSearch"
                        type="text"
                        placeholder="Search brands"
                        class="h-9 w-full rounded-lg border border-zinc-200 bg-zinc-50 px-3 pr-8 text-xs focus:outline-none focus:ring-1 focus:ring-[#D4AF37]"
                      />
                    </div>
                    <div class="max-h-40 space-y-1 overflow-y-auto pr-1 custom-scroll">
                      <label
                        v-for="brand in filteredBrands"
                        :key="brand"
                        class="flex items-center gap-2 text-xs text-zinc-700"
                      >
                        <input
                          v-model="filters.brands"
                          type="checkbox"
                          :value="brand"
                          class="h-3.5 w-3.5 rounded border-zinc-300 text-[#D4AF37] focus:ring-[#D4AF37]"
                        />
                        <span class="truncate">{{ brand }}</span>
                      </label>
                    </div>
                  </div>
                </details>

                <details open class="group rounded-xl border border-zinc-200/80 bg-white/70">
                  <summary class="flex cursor-pointer items-center justify-between px-4 py-3">
                    <span class="font-medium text-[#282828]">Type</span>
                    <ChevronDown class="h-4 w-4 text-zinc-400 group-open:rotate-180 transition-transform" />
                  </summary>
                  <div class="border-t border-zinc-100 px-4 py-3 space-y-2">
                    <label
                      v-for="type in wineTypes"
                      :key="type"
                      class="flex items-center gap-2 text-xs text-zinc-700"
                    >
                      <input
                        v-model="filters.types"
                        type="checkbox"
                        :value="type"
                        class="h-3.5 w-3.5 rounded border-zinc-300 text-[#D4AF37] focus:ring-[#D4AF37]"
                      />
                      <span>{{ type }}</span>
                    </label>
                  </div>
                </details>

                <details open class="group rounded-xl border border-zinc-200/80 bg-white/70">
                  <summary class="flex cursor-pointer items-center justify-between px-4 py-3">
                    <span class="font-medium text-[#282828]">Region</span>
                    <ChevronDown class="h-4 w-4 text-zinc-400 group-open:rotate-180 transition-transform" />
                  </summary>
                  <div class="border-t border-zinc-100 px-4 py-3 space-y-2 max-h-36 overflow-y-auto pr-1 custom-scroll">
                    <label
                      v-for="region in regions"
                      :key="region"
                      class="flex items-center gap-2 text-xs text-zinc-700"
                    >
                      <input
                        v-model="filters.regions"
                        type="checkbox"
                        :value="region"
                        class="h-3.5 w-3.5 rounded border-zinc-300 text-[#D4AF37] focus:ring-[#D4AF37]"
                      />
                      <span>{{ region }}</span>
                    </label>
                  </div>
                </details>

                <details open class="group rounded-xl border border-zinc-200/80 bg-white/70">
                  <summary class="flex cursor-pointer items-center justify-between px-4 py-3">
                    <span class="font-medium text-[#282828]">Rating</span>
                    <ChevronDown class="h-4 w-4 text-zinc-400 group-open:rotate-180 transition-transform" />
                  </summary>
                  <div class="border-t border-zinc-100 px-4 py-3 space-y-2 text-xs">
                    <button
                      v-for="rating in [4, 4.5, 3.5]"
                      :key="rating"
                      type="button"
                      class="flex w-full items-center justify-between rounded-lg border px-3 py-2 text-left"
                      :class="filters.minRating === rating ? 'border-[#D4AF37] bg-amber-50/40 text-[#282828]' : 'border-zinc-200 bg-white text-zinc-700 hover:bg-zinc-50'"
                      @click="filters.minRating = rating"
                    >
                      <span class="flex items-center gap-1.5">
                        <span class="flex items-center">
                          <Star
                            v-for="i in 5"
                            :key="i"
                            class="h-3.5 w-3.5"
                            :class="i <= Math.floor(rating) ? 'text-[#D4AF37] fill-[#D4AF37]' : 'text-zinc-300'"
                          />
                        </span>
                        <span>{{ rating }} & up</span>
                      </span>
                      <span class="text-[10px] text-zinc-400">{{ rating === 4.5 ? 'Top rated' : 'Popular' }}</span>
                    </button>
                  </div>
                </details>
              </div>
            </div>
          </aside>

          <!-- Main content -->
          <main class="space-y-4 lg:space-y-6">
            <!-- Top bar (desktop) -->
            <div class="hidden lg:flex items-center justify-between gap-4">
              <div class="flex items-center gap-3 text-xs text-zinc-500">
                <span>Sorted by</span>
                <select
                  v-model="sortBy"
                  class="h-9 rounded-full border border-zinc-200 bg-white px-3 pr-8 text-xs font-medium text-zinc-800 focus:outline-none focus:ring-1 focus:ring-[#D4AF37]"
                >
                  <option value="popularity">Most popular</option>
                  <option value="price-asc">Price: Low to High</option>
                  <option value="price-desc">Price: High to Low</option>
                  <option value="newest">Newest arrivals</option>
                </select>
              </div>

              <div class="flex items-center gap-2 text-xs text-zinc-500">
                <span>View</span>
                <button
                  type="button"
                  class="inline-flex items-center gap-1 rounded-full border px-3 py-1.5 text-xs font-medium"
                  :class="viewMode === 'grid' ? 'border-[#D4AF37] bg-amber-50/50 text-[#282828]' : 'border-zinc-200 bg-white text-zinc-600'"
                  @click="viewMode = 'grid'"
                >
                  Grid
                </button>
                <button
                  type="button"
                  class="inline-flex items-center gap-1 rounded-full border px-3 py-1.5 text-xs font-medium"
                  :class="viewMode === 'list' ? 'border-[#D4AF37] bg-amber-50/50 text-[#282828]' : 'border-zinc-200 bg-white text-zinc-600'"
                  @click="viewMode = 'list'"
                >
                  List
                </button>
              </div>
            </div>

            <!-- Active filters chip row (optional) -->
            <div v-if="activeFilterChips.length" class="flex flex-wrap items-center gap-2 text-xs">
              <span class="text-zinc-500">Active filters:</span>
              <button
                v-for="chip in activeFilterChips"
                :key="chip.id"
                type="button"
                class="inline-flex items-center gap-1 rounded-full bg-white border border-zinc-200 px-2.5 py-1 text-[11px] text-zinc-700 shadow-sm"
                @click="chip.onRemove()"
              >
                <span>{{ chip.label }}</span>
                <X class="h-3 w-3 text-zinc-400" />
              </button>
              <button
                type="button"
                class="ml-1 text-[11px] text-zinc-500 hover:text-zinc-700"
                @click="resetFilters"
              >
                Clear all
              </button>
            </div>

            <!-- Skeleton loading -->
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

            <!-- Product grid -->
            <div
              v-else
              :class="[
                'mt-2 grid gap-3 sm:gap-4 lg:gap-6',
                viewMode === 'grid'
                  ? 'grid-cols-2 sm:grid-cols-3 lg:grid-cols-4'
                  : 'grid-cols-1'
              ]"
            >
              <WineCard
                v-for="wine in visibleWines"
                :key="wine.id"
                :product="mapWineToCardProduct(wine)"
                :compact="viewMode === 'list'"
                @addToCart="() => handleAddToCart(wine)"
              />
            </div>

            <!-- Pagination / Load more -->
            <div v-if="!loading" class="mt-6 flex justify-center">
              <button
                v-if="visibleCount < filteredAndSortedWines.length"
                type="button"
                class="inline-flex items-center gap-2 rounded-full border border-[#D4AF37] px-6 py-2.5 text-sm font-semibold text-[#D4AF37] hover:bg-[#D4AF37] hover:text-[#282828]"
                @click="loadMore"
              >
                Load more
              </button>
            </div>
          </main>
        </div>
      </div>

      <!-- Mobile filters drawer -->
      <Transition
        enter-active-class="transition-opacity duration-200"
        leave-active-class="transition-opacity duration-200"
        enter-from-class="opacity-0"
        enter-to-class="opacity-100"
        leave-from-class="opacity-100"
        leave-to-class="opacity-0"
      >
        <div
          v-if="mobileFiltersOpen"
          class="fixed inset-0 z-40 flex lg:hidden"
        >
          <div
            class="flex-1 bg-black/40"
            @click="mobileFiltersOpen = false"
          ></div>
          <div class="relative w-full max-w-md ml-auto h-full bg-white rounded-l-3xl shadow-2xl flex flex-col">
            <div class="flex items-center justify-between px-4 py-3 border-b border-zinc-100">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.18em] text-zinc-500">
                  Filters
                </p>
                <p class="text-[11px] text-zinc-400">Refine {{ totalResults }} wines</p>
              </div>
              <button
                type="button"
                class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-zinc-100 text-zinc-500"
                @click="mobileFiltersOpen = false"
              >
                <X class="h-4 w-4" />
              </button>
            </div>

            <div class="flex-1 overflow-y-auto px-4 py-4 space-y-4 custom-scroll">
              <!-- Reuse same filter content as desktop -->
              <div class="space-y-3 text-sm">
                <div class="rounded-xl border border-zinc-200/80 bg-white/70">
                  <div class="px-4 py-3">
                    <p class="font-medium text-[#282828] mb-3">Price range</p>
                    <div class="flex items-center gap-2 text-xs text-zinc-500">
                      <span>Min</span>
                      <input
                        v-model.number="filters.minPrice"
                        type="number"
                        min="0"
                        class="h-9 w-full rounded-lg border border-zinc-200 bg-zinc-50 px-2 text-xs focus:outline-none focus:ring-1 focus:ring-[#D4AF37]"
                        placeholder="0"
                      />
                      <span>Max</span>
                      <input
                        v-model.number="filters.maxPrice"
                        type="number"
                        min="0"
                        class="h-9 w-full rounded-lg border border-zinc-200 bg-zinc-50 px-2 text-xs focus:outline-none focus:ring-1 focus:ring-[#D4AF37]"
                        placeholder="50000"
                      />
                    </div>
                    <p class="mt-2 text-[11px] text-zinc-400">Prices in NGN</p>
                  </div>
                </div>

                <div class="rounded-xl border border-zinc-200/80 bg-white/70">
                  <div class="px-4 py-3 space-y-3">
                    <p class="font-medium text-[#282828]">Brand / Vineyard</p>
                    <input
                      v-model="brandSearch"
                      type="text"
                      placeholder="Search brands"
                      class="h-9 w-full rounded-lg border border-zinc-200 bg-zinc-50 px-3 text-xs focus:outline-none focus:ring-1 focus:ring-[#D4AF37]"
                    />
                    <div class="max-h-40 space-y-1 overflow-y-auto pr-1 custom-scroll">
                      <label
                        v-for="brand in filteredBrands"
                        :key="brand"
                        class="flex items-center gap-2 text-xs text-zinc-700"
                      >
                        <input
                          v-model="filters.brands"
                          type="checkbox"
                          :value="brand"
                          class="h-3.5 w-3.5 rounded border-zinc-300 text-[#D4AF37] focus:ring-[#D4AF37]"
                        />
                        <span class="truncate">{{ brand }}</span>
                      </label>
                    </div>
                  </div>
                </div>

                <div class="rounded-xl border border-zinc-200/80 bg-white/70">
                  <div class="px-4 py-3 space-y-2">
                    <p class="font-medium text-[#282828]">Type</p>
                    <label
                      v-for="type in wineTypes"
                      :key="type"
                      class="flex items-center gap-2 text-xs text-zinc-700"
                    >
                      <input
                        v-model="filters.types"
                        type="checkbox"
                        :value="type"
                        class="h-3.5 w-3.5 rounded border-zinc-300 text-[#D4AF37] focus:ring-[#D4AF37]"
                      />
                      <span>{{ type }}</span>
                    </label>
                  </div>
                </div>

                <div class="rounded-xl border border-zinc-200/80 bg-white/70">
                  <div class="px-4 py-3 space-y-2 max-h-40 overflow-y-auto custom-scroll">
                    <p class="font-medium text-[#282828]">Region</p>
                    <label
                      v-for="region in regions"
                      :key="region"
                      class="flex items-center gap-2 text-xs text-zinc-700"
                    >
                      <input
                        v-model="filters.regions"
                        type="checkbox"
                        :value="region"
                        class="h-3.5 w-3.5 rounded border-zinc-300 text-[#D4AF37] focus:ring-[#D4AF37]"
                      />
                      <span>{{ region }}</span>
                    </label>
                  </div>
                </div>

                <div class="rounded-xl border border-zinc-200/80 bg-white/70">
                  <div class="px-4 py-3 space-y-2 text-xs">
                    <p class="font-medium text-[#282828] mb-1">Rating</p>
                    <button
                      v-for="rating in [4, 4.5, 3.5]"
                      :key="rating"
                      type="button"
                      class="flex w-full items-center justify-between rounded-lg border px-3 py-2 text-left"
                      :class="filters.minRating === rating ? 'border-[#D4AF37] bg-amber-50/40 text-[#282828]' : 'border-zinc-200 bg-white text-zinc-700 hover:bg-zinc-50'"
                      @click="filters.minRating = rating"
                    >
                      <span class="flex items-center gap-1.5">
                        <span class="flex items-center">
                          <Star
                            v-for="i in 5"
                            :key="i"
                            class="h-3.5 w-3.5"
                            :class="i <= Math.floor(rating) ? 'text-[#D4AF37] fill-[#D4AF37]' : 'text-zinc-300'"
                          />
                        </span>
                        <span>{{ rating }} & up</span>
                      </span>
                      <span class="text-[10px] text-zinc-400">{{ rating === 4.5 ? 'Top rated' : 'Popular' }}</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <div class="border-t border-zinc-100 px-4 py-3 flex items-center justify-between text-xs">
              <button
                type="button"
                class="text-zinc-500 hover:text-zinc-700"
                @click="resetFilters"
              >
                Clear all
              </button>
              <button
                type="button"
                class="inline-flex items-center justify-center rounded-full bg-[#D4AF37] px-4 py-2 text-xs font-semibold text-[#282828]"
                @click="mobileFiltersOpen = false"
              >
                Show results
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { ChevronDown, Filter, SlidersHorizontal, Star, X } from 'lucide-vue-next'
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

const allWines = ref<ProductWithRating[]>([])

const loading = ref(true)
const showAgeGate = ref(true)
const mobileFiltersOpen = ref(false)
const addingToCartId = ref<string | null>(null)

const wineTypes = ['Red', 'White', 'Rosé', 'Sparkling'] as const

const mapWineToCardProduct = (product: ProductWithRating) => {
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
    badges: isBestSeller(product) ? ['Best Seller'] : undefined,
    rating: product.averageRating,
    specs: {
      type: getTypeLabel(product),
      abv: product.alcohol_percentage != null ? `${product.alcohol_percentage}%` : undefined
    }
  }
}

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

const getVolumeLabel = (product: ProductWithRating): string => {
  return product.volume || '75cl'
}

const getAbvLabel = (product: ProductWithRating): string => {
  return product.alcohol_percentage != null ? `${product.alcohol_percentage}% ABV` : 'Wine & spirits'
}

const getRegionLabel = (product: ProductWithRating): string => {
  return product.country_of_origin || 'From renowned regions'
}

const regions = computed(() => {
  const set = new Set<string>()
  allWines.value.forEach(w => set.add(getRegionLabel(w)))
  return Array.from(set).sort()
})

const allBrands = computed(() => {
  const set = new Set<string>()
  allWines.value.forEach(w => set.add(getBrandLabel(w)))
  return Array.from(set).sort()
})

const sortBy = ref<'popularity' | 'price-asc' | 'price-desc' | 'newest'>('popularity')
const viewMode = ref<'grid' | 'list'>('grid')

const filters = ref({
  minPrice: undefined as number | undefined,
  maxPrice: undefined as number | undefined,
  brands: [] as string[],
  types: [] as string[],
  regions: [] as string[],
  minRating: undefined as number | undefined
})

const brandSearch = ref('')

const route = useRoute()

type CategoryKey = 'all' | 'red' | 'white' | 'rose' | 'sparkling'

const categoryKey = computed<CategoryKey>(() => {
  const fromParam = (route.params.category as string | undefined) || (route.query.category as string | undefined)
  if (!fromParam) return 'all'
  const value = fromParam.toString().toLowerCase()
  if (value.includes('red')) return 'red'
  if (value.includes('white')) return 'white'
  if (value.includes('spark')) return 'sparkling'
  if (value.includes('ros')) return 'rose'
  return 'all'
})

const categoryMeta = computed(() => {
  switch (categoryKey.value) {
    case 'red':
      return { title: 'Premium Red Wines', breadcrumb: 'Red Wine', typeFilter: ['Red'] as string[] }
    case 'white':
      return { title: 'Premium White Wines', breadcrumb: 'White Wine', typeFilter: ['White'] as string[] }
    case 'rose':
      return { title: 'Premium Rosé Wines', breadcrumb: 'Rosé Wine', typeFilter: ['Rosé'] as string[] }
    case 'sparkling':
      return { title: 'Premium Sparkling Wines', breadcrumb: 'Sparkling Wine', typeFilter: ['Sparkling'] as string[] }
    case 'all':
    default:
      return { title: 'Premium Wines & Spirits', breadcrumb: 'Wines & Spirits', typeFilter: [] as string[] }
  }
})

const searchTerm = computed(() => {
  const raw = (route.query.search as string | undefined) || ''
  return raw.trim().toLowerCase()
})

const featuredOnly = computed(() => route.query.featured === 'true')

watch(
  categoryKey,
  key => {
    filters.value.types = []
    if (key === 'red') filters.value.types = ['Red']
    if (key === 'white') filters.value.types = ['White']
    if (key === 'rose') filters.value.types = ['Rosé']
    if (key === 'sparkling') filters.value.types = ['Sparkling']
  },
  { immediate: true }
)

const filteredBrands = computed(() => {
  const search = brandSearch.value.trim().toLowerCase()
  return allBrands.value.filter(b =>
    search ? b.toLowerCase().includes(search) : true
  )
})

const filteredAndSortedWines = computed(() => {
  let wines = allWines.value.slice()

  if (featuredOnly.value) {
    wines = wines.filter(w => w.is_featured)
  }

  if (searchTerm.value) {
    wines = wines.filter(w => {
      const base = [
        w.name,
        w.brand,
        w.country_of_origin,
        w.description,
        w.short_description,
        getTypeLabel(w)
      ]
        .filter(Boolean)
        .join(' ')
        .toLowerCase()

      const tags = Array.isArray(w.tags) ? w.tags.join(' ').toLowerCase() : ''

      return base.includes(searchTerm.value) || tags.includes(searchTerm.value)
    })
  }

  if (filters.value.minPrice != null) {
    wines = wines.filter(w => w.price >= filters.value.minPrice!)
  }
  if (filters.value.maxPrice != null && filters.value.maxPrice > 0) {
    wines = wines.filter(w => w.price <= filters.value.maxPrice!)
  }
  if (filters.value.brands.length) {
    wines = wines.filter(w => filters.value.brands.includes(getBrandLabel(w)))
  }
  if (filters.value.types.length) {
    wines = wines.filter(w => filters.value.types.includes(getTypeLabel(w)))
  }
  if (filters.value.regions.length) {
    wines = wines.filter(w => filters.value.regions.includes(getRegionLabel(w)))
  }
  if (filters.value.minRating != null) {
    wines = wines.filter(w => (w.averageRating || 0) >= filters.value.minRating!)
  }

  wines.sort((a, b) => {
    switch (sortBy.value) {
      case 'price-asc':
        return a.price - b.price
      case 'price-desc':
        return b.price - a.price
      case 'newest':
        return new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
      case 'popularity':
      default:
        return (b.reviewCount || 0) - (a.reviewCount || 0)
    }
  })

  return wines
})

const visibleCount = ref(12)

const visibleWines = computed(() => filteredAndSortedWines.value.slice(0, visibleCount.value))

const totalResults = computed(() => filteredAndSortedWines.value.length)

const sortLabel = computed(() => {
  switch (sortBy.value) {
    case 'price-asc':
      return 'Price: Low to High'
    case 'price-desc':
      return 'Price: High to Low'
    case 'newest':
      return 'Newest arrivals'
    case 'popularity':
    default:
      return 'Most popular'
  }
})

const activeFilterChips = computed(() => {
  const chips: { id: string; label: string; onRemove: () => void }[] = []

  if (filters.value.minPrice != null) {
    chips.push({
      id: 'minPrice',
      label: `Min ₦${filters.value.minPrice.toLocaleString()}`,
      onRemove: () => {
        filters.value.minPrice = undefined
      }
    })
  }

  if (filters.value.maxPrice != null && filters.value.maxPrice > 0) {
    chips.push({
      id: 'maxPrice',
      label: `Max ₦${filters.value.maxPrice.toLocaleString()}`,
      onRemove: () => {
        filters.value.maxPrice = undefined
      }
    })
  }

  filters.value.brands.forEach(brand => {
    chips.push({
      id: `brand-${brand}`,
      label: brand,
      onRemove: () => {
        filters.value.brands = filters.value.brands.filter(b => b !== brand)
      }
    })
  })

  filters.value.types.forEach(type => {
    chips.push({
      id: `type-${type}`,
      label: type,
      onRemove: () => {
        filters.value.types = filters.value.types.filter(t => t !== type)
      }
    })
  })

  filters.value.regions.forEach(region => {
    chips.push({
      id: `region-${region}`,
      label: region,
      onRemove: () => {
        filters.value.regions = filters.value.regions.filter(r => r !== region)
      }
    })
  })

  if (filters.value.minRating != null) {
    chips.push({
      id: 'rating',
      label: `${filters.value.minRating}+ stars`,
      onRemove: () => {
        filters.value.minRating = undefined
      }
    })
  }

  return chips
})

const resetFilters = () => {
  filters.value = {
    minPrice: undefined,
    maxPrice: undefined,
    brands: [],
    types: [],
    regions: [],
    minRating: undefined
  }
}

const loadMore = () => {
  visibleCount.value += 8
}

const getDiscountPercent = (product: ProductWithRating) => {
  if (!product.compare_at_price || product.compare_at_price <= product.price) return null
  return Math.round(((product.compare_at_price - product.price) / product.compare_at_price) * 100)
}

const isBestSeller = (product: ProductWithRating) => {
  return Array.isArray(product.tags) && (product.tags.includes('bestseller') || product.tags.includes('best-seller'))
}

const handleAddToCart = async (product: ProductWithRating) => {
  if (!product.id) return
  addingToCartId.value = product.id
  const { success } = await addToCart(product.id, 1)
  if (!success) {
    console.error('Failed to add product to cart')
  }
  addingToCartId.value = null
}

const fetchProducts = async () => {
  loading.value = true
  try {
    const { data: productsData, error: productsError } = await supabase
      .from('products')
      .select('*')
      .eq('is_active', true)
      .order('created_at', { ascending: false })
      .limit(60)

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

    allWines.value = enriched
  } catch (error) {
    console.error('Error fetching wines:', error)
    allWines.value = []
  } finally {
    loading.value = false
  }
}

const confirmAge = () => {
  showAgeGate.value = false
}

const handleUnderAge = () => {
  alert('You need to be 18+ to access this section.')
}

onMounted(() => {
  fetchProducts()
})
</script>

<style scoped>
.custom-scroll {
  scrollbar-width: thin;
  scrollbar-color: rgba(148, 163, 184, 0.7) transparent;
}

.custom-scroll::-webkit-scrollbar {
  width: 6px;
}

.custom-scroll::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scroll::-webkit-scrollbar-thumb {
  background-color: rgba(148, 163, 184, 0.7);
  border-radius: 9999px;
}

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
