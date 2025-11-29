<template>
  <NuxtLink :to="to" class="card hover:shadow-lg transition-shadow cursor-pointer block">
    <div class="flex items-start justify-between mb-2">
      <div>
        <p class="text-xs text-zinc-500 mb-1 font-mono">Order {{ order.order_number }}</p>
        <p class="text-lg font-semibold text-zinc-900">
          ${{ order.total.toFixed(2) }}
        </p>
      </div>
      <span
        class="px-3 py-1 rounded-full text-xs font-medium"
        :class="getStatusClass(order.status)"
      >
        {{ capitalise(order.status) }}
      </span>
    </div>
    <p class="text-xs text-zinc-600 mb-1">
      Placed on {{ formatDate(order.created_at) }}
    </p>
    <p v-if="subtitle" class="text-xs text-zinc-500">
      {{ subtitle }}
    </p>
  </NuxtLink>
</template>

<script setup lang="ts">
import type { Database } from '~/types/database'

type Order = Database['public']['Tables']['orders']['Row']

const props = defineProps<{
  order: Order
  to: string
  subtitle?: string
}>()

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const capitalise = (value: string) => value.charAt(0).toUpperCase() + value.slice(1)

const getStatusClass = (status: string) => {
  const classes: Record<string, string> = {
    pending: 'bg-yellow-100 text-yellow-800',
    processing: 'bg-blue-100 text-blue-800',
    shipped: 'bg-indigo-100 text-indigo-800',
    delivered: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-zinc-100 text-zinc-800'
}
</script>
