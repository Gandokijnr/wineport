<template>
  <div>
    <section class="relative h-[600px] flex items-center justify-center bg-gradient-to-br from-zinc-50 to-zinc-100">
      <div class="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImdyaWQiIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTSAxMCAwIEwgMCAwIDAgMTAiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzAwMCIgc3Ryb2tlLW9wYWNpdHk9IjAuMDMiIHN0cm9rZS13aWR0aD0iMSIvPjwvcGF0dGVybj48L2RlZnM+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0idXJsKCNncmlkKSIvPjwvc3ZnPg==')] opacity-40"></div>

      <div class="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h1 class="text-5xl md:text-6xl font-bold text-zinc-900 mb-6 leading-tight">
          Premium Beverage Commerce,<br />Reimagined
        </h1>
        <p class="text-xl text-zinc-600 mb-8 max-w-2xl mx-auto leading-relaxed">
          Experience a new standard in beverage procurement. Designed for discerning consumers and businesses who demand excellence.
        </p>
        <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
          <NuxtLink to="/products" class="btn btn-primary px-8 py-3 text-base">
            Explore Products
          </NuxtLink>
        </div>
      </div>
    </section>

    <section class="py-20 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl md:text-4xl font-bold text-zinc-900 mb-4">
            Featured Products
          </h2>
          <p class="text-lg text-zinc-600 max-w-2xl mx-auto">
            Curated selections from our premium collection
          </p>
        </div>

        <div v-if="loading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <div v-for="i in 4" :key="i" class="card animate-pulse">
            <div class="aspect-square bg-zinc-200 rounded-lg mb-4"></div>
            <div class="h-4 bg-zinc-200 rounded mb-2"></div>
            <div class="h-3 bg-zinc-200 rounded w-2/3"></div>
          </div>
        </div>

        <div v-else-if="featuredProducts.length > 0" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <ProductCard
            v-for="product in featuredProducts"
            :key="product.id"
            :product="product"
          />
        </div>

        <div v-else class="text-center py-12">
          <p class="text-zinc-600">No featured products available at the moment.</p>
        </div>
      </div>
    </section>

    <section class="py-20 bg-zinc-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="text-center">
            <div class="w-16 h-16 bg-zinc-900 rounded-full flex items-center justify-center mx-auto mb-4">
              <Package class="text-white" :size="28" />
            </div>
            <h3 class="text-xl font-semibold text-zinc-900 mb-2">Fast Delivery</h3>
            <p class="text-zinc-600 leading-relaxed">
              Same-day delivery available in select areas. Track your order in real-time.
            </p>
          </div>

          <div class="text-center">
            <div class="w-16 h-16 bg-zinc-900 rounded-full flex items-center justify-center mx-auto mb-4">
              <Shield class="text-white" :size="28" />
            </div>
            <h3 class="text-xl font-semibold text-zinc-900 mb-2">Quality Guaranteed</h3>
            <p class="text-zinc-600 leading-relaxed">
              Every product is carefully sourced and verified for authenticity.
            </p>
          </div>

          <div class="text-center">
            <div class="w-16 h-16 bg-zinc-900 rounded-full flex items-center justify-center mx-auto mb-4">
              <Headphones class="text-white" :size="28" />
            </div>
            <h3 class="text-xl font-semibold text-zinc-900 mb-2">Expert Support</h3>
            <p class="text-zinc-600 leading-relaxed">
              Our team is available to help with product selection and orders.
            </p>
          </div>
        </div>
      </div>
    </section>

    <section class="py-20 bg-zinc-900 text-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="text-3xl md:text-4xl font-bold mb-6">
              B2B Solutions Built for Scale
            </h2>
            <p class="text-zinc-300 text-lg mb-8 leading-relaxed">
              Whether you run a restaurant, hotel, or event space, our business solutions provide volume pricing, dedicated account management, and flexible delivery schedules.
            </p>
            <ul class="space-y-4 mb-8">
              <li class="flex items-start gap-3">
                <Check class="text-green-400 flex-shrink-0 mt-1" :size="20" />
                <span class="text-zinc-300">Wholesale pricing with volume discounts</span>
              </li>
              <li class="flex items-start gap-3">
                <Check class="text-green-400 flex-shrink-0 mt-1" :size="20" />
                <span class="text-zinc-300">Dedicated account manager</span>
              </li>
              <li class="flex items-start gap-3">
                <Check class="text-green-400 flex-shrink-0 mt-1" :size="20" />
                <span class="text-zinc-300">Flexible payment terms</span>
              </li>
              <li class="flex items-start gap-3">
                <Check class="text-green-400 flex-shrink-0 mt-1" :size="20" />
                <span class="text-zinc-300">Custom delivery scheduling</span>
              </li>
            </ul>
            <NuxtLink to="/b2b" class="btn bg-white text-zinc-900 hover:bg-zinc-100 px-8 py-3">
              Learn More
            </NuxtLink>
          </div>
          <div class="relative">
            <div class="aspect-square bg-zinc-800 rounded-2xl"></div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { Package, Shield, Headphones, Check } from 'lucide-vue-next'
import type { Database } from '~/types/database'

type Product = Database['public']['Tables']['products']['Row']

const supabase = useSupabase()
const loading = ref(true)
const featuredProducts = ref<Product[]>([])

onMounted(async () => {
  try {
    const { data, error } = await supabase
      .from('products')
      .select('*')
      .eq('is_featured', true)
      .eq('is_active', true)
      .limit(4)

    if (error) throw error
    featuredProducts.value = data || []
  } catch (error) {
    console.error('Error fetching featured products:', error)
  } finally {
    loading.value = false
  }
})

useHead({
  title: 'LiquidLogistics - Premium Beverage Commerce',
  meta: [
    {
      name: 'description',
      content: 'Experience a new standard in beverage procurement. Designed for discerning consumers and businesses who demand excellence.'
    }
  ]
})
</script>
