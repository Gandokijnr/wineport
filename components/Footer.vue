<template>
  <footer class="bg-zinc-900 text-zinc-400">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
          <h3 class="text-white text-lg font-bold mb-4">Flux</h3>
          <p class="text-sm leading-relaxed">
            Premium beverage commerce platform serving both retail and business customers with excellence.
          </p>
        </div>

        <div>
          <h4 class="text-white text-sm font-semibold mb-4">Shop</h4>
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/products" class="text-sm hover:text-white transition-colors">
                All Products
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/categories" class="text-sm hover:text-white transition-colors">
                Categories
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/products?featured=true" class="text-sm hover:text-white transition-colors">
                Featured
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/products?on-sale=true" class="text-sm hover:text-white transition-colors">
                On Sale
              </NuxtLink>
            </li>
          </ul>
        </div>

        <div>
          <h4 class="text-white text-sm font-semibold mb-4">Business</h4>
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/b2b" class="text-sm hover:text-white transition-colors">
                B2B Solutions
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/wholesale" class="text-sm hover:text-white transition-colors">
                Wholesale Pricing
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/corporate" class="text-sm hover:text-white transition-colors">
                Corporate Accounts
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/partnerships" class="text-sm hover:text-white transition-colors">
                Partnerships
              </NuxtLink>
            </li>
          </ul>
        </div>

        <div>
          <h4 class="text-white text-sm font-semibold mb-4">Support</h4>
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/help" class="text-sm hover:text-white transition-colors">
                Help Center
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/shipping" class="text-sm hover:text-white transition-colors">
                Shipping Info
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/returns" class="text-sm hover:text-white transition-colors">
                Returns
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/contact" class="text-sm hover:text-white transition-colors">
                Contact Us
              </NuxtLink>
            </li>
          </ul>
        </div>
      </div>

      <div class="mt-12 pt-8 border-t border-zinc-800">
        <div class="flex flex-col md:flex-row justify-between items-center gap-4">
          <p class="text-sm">
            &copy; {{ new Date().getFullYear() }} Flux. All rights reserved.
          </p>
          <div class="flex items-center gap-6">
            <NuxtLink to="/privacy" class="text-sm hover:text-white transition-colors">
              Privacy Policy
            </NuxtLink>
            <NuxtLink to="/terms" class="text-sm hover:text-white transition-colors">
              Terms of Service
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
</script>
