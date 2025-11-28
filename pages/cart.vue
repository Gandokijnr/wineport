<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <h1 class="text-4xl font-bold text-zinc-900 mb-8">Shopping Cart</h1>

      <div v-if="loading" class="space-y-4">
        <div v-for="i in 3" :key="i" class="card animate-pulse">
          <div class="flex gap-6">
            <div class="w-24 h-24 bg-zinc-200 rounded-lg"></div>
            <div class="flex-1 space-y-3">
              <div class="h-4 bg-zinc-200 rounded w-1/2"></div>
              <div class="h-3 bg-zinc-200 rounded w-1/4"></div>
            </div>
          </div>
        </div>
      </div>

      <div v-else-if="cartItems.length === 0" class="text-center py-16">
        <ShoppingCart :size="64" class="mx-auto text-zinc-300 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">Your cart is empty</h2>
        <p class="text-zinc-600 mb-6">Add some products to get started</p>
        <NuxtLink to="/products" class="btn btn-primary">
          Browse Products
        </NuxtLink>
      </div>

      <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-2 space-y-4">
          <div
            v-for="item in cartItems"
            :key="item.id"
            class="card"
          >
            <div class="flex gap-6">
              <NuxtLink
                :to="`/products/${item.product?.slug}`"
                class="flex-shrink-0"
              >
                <div class="w-24 h-24 bg-zinc-100 rounded-lg overflow-hidden">
                  <img
                    v-if="item.product?.image_urls?.[0]"
                    :src="item.product.image_urls[0]"
                    :alt="item.product?.name"
                    class="w-full h-full object-cover"
                  />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <Wine :size="32" class="text-zinc-300" />
                  </div>
                </div>
              </NuxtLink>

              <div class="flex-1 min-w-0">
                <NuxtLink
                  :to="`/products/${item.product?.slug}`"
                  class="text-lg font-semibold text-zinc-900 hover:text-zinc-600 transition-colors line-clamp-2"
                >
                  {{ item.product?.name }}
                </NuxtLink>
                <p v-if="item.product?.brand" class="text-sm text-zinc-600 mt-1">
                  {{ item.product.brand }}
                </p>
                <p class="text-lg font-bold text-zinc-900 mt-2">
                  ${{ (item.product?.price || 0).toFixed(2) }}
                </p>
              </div>

              <div class="flex flex-col items-end justify-between">
                <button
                  @click="removeFromCart(item.id)"
                  class="text-zinc-400 hover:text-red-600 transition-colors"
                  aria-label="Remove item"
                >
                  <X :size="20" />
                </button>

                <div class="flex items-center border border-zinc-300 rounded-lg">
                  <button
                    @click="updateQuantity(item.id, item.quantity - 1)"
                    class="px-3 py-1 hover:bg-zinc-50 transition-colors"
                    :disabled="item.quantity <= 1"
                  >
                    <Minus :size="16" />
                  </button>
                  <span class="px-4 text-sm font-medium">{{ item.quantity }}</span>
                  <button
                    @click="updateQuantity(item.id, item.quantity + 1)"
                    class="px-3 py-1 hover:bg-zinc-50 transition-colors"
                    :disabled="item.quantity >= (item.product?.stock_quantity || 0)"
                  >
                    <Plus :size="16" />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="card sticky top-24">
            <h2 class="text-xl font-bold text-zinc-900 mb-6">Order Summary</h2>

            <div class="space-y-3 mb-6">
              <div class="flex items-center justify-between text-sm">
                <span class="text-zinc-600">Subtotal</span>
                <span class="font-medium text-zinc-900">${cartTotal.toFixed(2)}</span>
              </div>
              <div class="flex items-center justify-between text-sm">
                <span class="text-zinc-600">Shipping</span>
                <span class="font-medium text-zinc-900">Calculated at checkout</span>
              </div>
              <div class="flex items-center justify-between text-sm">
                <span class="text-zinc-600">Tax</span>
                <span class="font-medium text-zinc-900">Calculated at checkout</span>
              </div>
            </div>

            <div class="pt-6 border-t border-zinc-200 mb-6">
              <div class="flex items-center justify-between text-lg">
                <span class="font-semibold text-zinc-900">Total</span>
                <span class="font-bold text-zinc-900">${cartTotal.toFixed(2)}</span>
              </div>
            </div>

            <NuxtLink to="/checkout" class="btn btn-primary w-full py-3 mb-3">
              Proceed to Checkout
            </NuxtLink>

            <NuxtLink to="/products" class="btn btn-secondary w-full py-3">
              Continue Shopping
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ShoppingCart, Wine, X, Minus, Plus } from 'lucide-vue-next'

const { cartItems, cartTotal, loading, fetchCart, updateQuantity: updateCartQuantity, removeFromCart: removeCartItem } = useCart()

const updateQuantity = async (itemId: string, quantity: number) => {
  await updateCartQuantity(itemId, quantity)
}

const removeFromCart = async (itemId: string) => {
  await removeCartItem(itemId)
}

onMounted(() => {
  fetchCart()
})

useHead({
  title: 'Shopping Cart - LiquidLogistics',
  meta: [
    {
      name: 'description',
      content: 'Review your cart and proceed to checkout'
    }
  ]
})
</script>
