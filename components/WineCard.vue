<template>
  <NuxtLink
    :to="productLink"
    :class="[
      'group relative rounded-xl border border-zinc-100 bg-white shadow-sm transition-all duration-200 hover:-translate-y-1 hover:shadow-xl overflow-hidden cursor-pointer',
      compact ? 'flex flex-row' : 'flex flex-col'
    ]"
  >
    <!-- Image area -->
    <div
      :class="[
        'relative bg-zinc-50 flex items-center justify-center px-3',
        compact ? 'pt-3 pb-3 w-28 sm:w-32 flex-shrink-0' : 'pt-4 pb-3'
      ]"
    >
      <!-- Discount badge + custom badges (top-left) -->
      <div class="absolute left-2 top-2 z-10 flex flex-col gap-1">
        <span
          v-if="discountPercent"
          class="inline-flex items-center rounded-full bg-rose-50 px-2 py-0.5 text-[10px] font-semibold text-rose-600 border border-rose-100"
        >
          -{{ discountPercent }}%
        </span>
        <span
          v-for="badge in (product.badges || [])"
          :key="badge"
          class="inline-flex items-center rounded-full bg-white/90 px-2 py-0.5 text-[10px] font-semibold uppercase tracking-[0.16em] text-zinc-500 border border-zinc-200/80"
        >
          {{ badge }}
        </span>
      </div>

      <!-- Wishlist heart (top-right) -->
      <button
        type="button"
        class="absolute right-2.5 top-2.5 z-10 inline-flex h-8 w-8 items-center justify-center rounded-full border border-zinc-200 bg-white/80 text-zinc-400 backdrop-blur-sm transition-all duration-150 hover:border-[#D4AF37] hover:text-[#D4AF37] hover:scale-105"
        @click.stop.prevent="toggleWishlist(String(product.id))"
      >
        <Heart
          class="h-4 w-4"
          :class="isWishlisted ? 'fill-[#D4AF37] text-[#D4AF37]' : ''"
        />
      </button>

      <!-- Bottle image -->
      <div
        :class="[
          'w-full flex items-center justify-center',
          compact ? 'aspect-[3/5]' : 'aspect-[3/4]'
        ]"
      >
        <img
          v-if="product.image"
          :src="product.image"
          :alt="product.name"
          loading="lazy"
          class="h-full w-auto object-contain transition-transform duration-300 group-hover:scale-105 drop-shadow-sm"
        />
        <div v-else class="flex h-full w-full items-center justify-center text-zinc-300">
          <Wine class="h-10 w-10" />
        </div>
      </div>

      <!-- Desktop hover Add to Cart (overlays bottom of image area, grid view only) -->
      <div
        v-if="!compact"
        class="pointer-events-none absolute inset-x-2 bottom-2 hidden sm:block"
      >
        <button
          type="button"
          class="pointer-events-auto inline-flex w-full items-center justify-center rounded-full bg-[#D4AF37] px-3 py-2 text-[11px] font-semibold text-[#282828] shadow-[0_18px_40px_-24px_rgba(0,0,0,0.9)] opacity-0 translate-y-2 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-200"
          @click.stop.prevent="handleAddToCart"
        >
          <ShoppingCart class="mr-1.5 h-3.5 w-3.5" />
          Add to cart
        </button>
      </div>
    </div>

    <!-- Content area -->
    <div
      :class="[
        'flex flex-1 flex-col px-3',
        compact ? 'gap-1 pb-2 pt-1' : 'gap-1.5 pb-3 pt-1'
      ]"
    >
      <!-- Brand & title -->
      <p class="text-[10px] font-semibold uppercase tracking-[0.18em] text-zinc-500">
        {{ product.brand }}
      </p>
      <h3
        :class="[
          'font-serif text-sm font-medium text-[#282828] leading-snug line-clamp-2',
          compact ? '' : 'min-h-[2.3rem]'
        ]"
      >
        {{ product.name }}
      </h3>

      <!-- Attributes row -->
      <div
        :class="[
          'flex flex-wrap items-center gap-1.5 text-[11px] text-zinc-600',
          compact ? 'mt-0.5' : 'mt-1'
        ]"
      >
        <span
          v-if="product.specs?.type"
          class="inline-flex items-center rounded-full bg-zinc-50 px-2 py-0.5 border border-zinc-200/80"
        >
          {{ product.specs.type }}
        </span>
        <span
          v-if="product.specs?.abv"
          class="inline-flex items-center rounded-full bg-zinc-50 px-2 py-0.5 border border-zinc-200/80"
        >
          {{ product.specs.abv }} ABV
        </span>
        <span
          v-if="product.specs?.year"
          class="inline-flex items-center rounded-full bg-zinc-50 px-2 py-0.5 border border-zinc-200/80"
        >
          {{ product.specs.year }}
        </span>
      </div>

      <!-- Rating -->
      <div
        v-if="product.rating"
        :class="[
          'flex items-center gap-1.5 text-[11px] text-zinc-600',
          compact ? 'mt-0.5' : 'mt-1'
        ]"
      >
        <Star class="h-3.5 w-3.5 text-[#D4AF37] fill-[#D4AF37]" />
        <span class="font-medium text-zinc-800">{{ product.rating.toFixed(1) }}</span>
      </div>

      <!-- Price & mobile CTA -->
      <div
        :class="[
          'flex items-end justify-between gap-2',
          compact ? 'mt-1' : 'mt-1.5'
        ]"
      >
        <div class="flex flex-col">
          <div class="flex items-baseline gap-1">
            <span class="text-sm font-semibold text-[#282828]">
              ₦{{ product.price.toLocaleString() }}
            </span>
            <span
              v-if="product.oldPrice && product.oldPrice > product.price"
              class="text-[11px] text-zinc-400 line-through"
            >
              ₦{{ product.oldPrice.toLocaleString() }}
            </span>
          </div>
        </div>

        <!-- Mobile always-on CTA -->
        <button
          type="button"
          class="inline-flex items-center justify-center rounded-full bg-[#D4AF37] text-[#282828] h-8 w-8 text-xs font-semibold shadow-sm sm:hidden"
          @click.stop.prevent="handleAddToCart"
        >
          <ShoppingCart class="h-4 w-4" />
        </button>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Heart, ShoppingCart, Star, Wine } from 'lucide-vue-next'

interface WineCardSpecs {
  abv?: string
  year?: string | number
  color?: string
  type?: string
}

interface WineCardProduct {
  id: string | number
  slug?: string
  name: string
  brand: string
  price: number
  oldPrice?: number
  image: string
  badges?: string[]
  rating?: number
  specs?: WineCardSpecs
}

interface Props {
  product: WineCardProduct
  compact?: boolean
}

const props = defineProps<Props>()

const emit = defineEmits<{
  (e: 'addToCart', product: WineCardProduct): void
}>()

const { wishlistIds, toggleWishlist } = useWishlist()

const isWishlisted = computed(() => wishlistIds.value.includes(String(props.product.id)))

const productLink = computed(() => {
  const slug = props.product.slug ?? String(props.product.id)
  return `/products/${slug}`
})

const discountPercent = computed(() => {
  if (!props.product.oldPrice || props.product.oldPrice <= props.product.price) return null
  return Math.round(((props.product.oldPrice - props.product.price) / props.product.oldPrice) * 100)
})

const handleAddToCart = () => {
  emit('addToCart', props.product)
}
</script>
