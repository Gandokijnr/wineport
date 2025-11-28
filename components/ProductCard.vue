<template>
  <NuxtLink
    :to="`/products/${product.slug}`"
    class="card group cursor-pointer"
  >
    <div class="aspect-square bg-zinc-100 rounded-lg mb-4 overflow-hidden relative">
      <img
        v-if="mainImage"
        :src="mainImage"
        :alt="product.name"
        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
      />
      <div
        v-else
        class="w-full h-full flex items-center justify-center"
      >
        <Wine :size="48" class="text-zinc-300" />
      </div>

      <div
        v-if="product.compare_at_price && product.compare_at_price > product.price"
        class="absolute top-3 right-3 bg-red-500 text-white text-xs font-semibold px-2 py-1 rounded"
      >
        SALE
      </div>
    </div>

    <div class="space-y-2">
      <div class="flex items-start justify-between gap-2">
        <h3 class="font-semibold text-zinc-900 group-hover:text-zinc-600 transition-colors line-clamp-2">
          {{ product.name }}
        </h3>
      </div>

      <div class="flex items-center gap-2 text-sm text-zinc-600">
        <span v-if="product.brand">{{ product.brand }}</span>
        <span v-if="product.brand && product.volume">&middot;</span>
        <span v-if="product.volume">{{ product.volume }}</span>
      </div>

      <div class="flex items-center gap-2">
        <span class="text-lg font-bold text-zinc-900">
          ${{ product.price.toFixed(2) }}
        </span>
        <span
          v-if="product.compare_at_price && product.compare_at_price > product.price"
          class="text-sm text-zinc-500 line-through"
        >
          ${{ product.compare_at_price.toFixed(2) }}
        </span>
      </div>

      <div
        v-if="product.stock_quantity <= product.low_stock_threshold && product.stock_quantity > 0"
        class="flex items-center gap-1 text-xs text-orange-600"
      >
        <AlertCircle :size="14" />
        <span>Low stock</span>
      </div>

      <div
        v-else-if="product.stock_quantity === 0"
        class="flex items-center gap-1 text-xs text-red-600"
      >
        <AlertCircle :size="14" />
        <span>Out of stock</span>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup lang="ts">
import { Wine, AlertCircle } from 'lucide-vue-next'
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']

interface Props {
  product: Product
}

const props = defineProps<Props>()

const mainImage = computed(() => {
  if (Array.isArray(props.product.image_urls) && props.product.image_urls.length > 0) {
    return props.product.image_urls[0]
  }
  return null
})
</script>
