<template>
  <section aria-label="Order status timeline">
    <ol class="relative border-l border-zinc-200 ml-3 space-y-4">
      <li
        v-for="event in events"
        :key="event.id"
        class="ml-4"
      >
        <div class="absolute -left-1.5 mt-1.5 h-3 w-3 rounded-full border-2 border-white"
             :class="isCurrent(event) ? 'bg-zinc-900' : 'bg-zinc-300'" />
        <p class="text-xs font-semibold text-zinc-900">
          {{ capitalise(event.status) }}
        </p>
        <p v-if="event.note" class="text-xs text-zinc-600 mt-0.5">
          {{ event.note }}
        </p>
        <p class="text-[11px] text-zinc-400 mt-0.5">
          {{ formatDate(event.created_at) }}
        </p>
      </li>
    </ol>
  </section>
</template>

<script setup lang="ts">
import type { Database } from '~/types/database'

type OrderStatusEvent = Database['public']['Tables']['order_status_events']['Row']

const props = defineProps<{
  events: OrderStatusEvent[]
  currentStatus: OrderStatusEvent['status']
}>()

const formatDate = (date: string) => {
  return new Date(date).toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const capitalise = (value: string) => value.charAt(0).toUpperCase() + value.slice(1)

const isCurrent = (event: OrderStatusEvent) => {
  return event.status === props.currentStatus
}
</script>
