<template>
  <article
    class="card cursor-pointer focus:outline-none focus:ring-2 focus:ring-zinc-900"
    :aria-label="`Address for ${address.first_name} ${address.last_name}`"
  >
    <div class="flex items-start justify-between gap-4">
      <div class="text-sm text-zinc-700 space-y-1">
        <p class="font-semibold text-zinc-900">
          {{ address.first_name }} {{ address.last_name }}
        </p>
        <p v-if="address.company" class="text-xs text-zinc-500">
          {{ address.company }}
        </p>
        <p>{{ address.address_line1 }}</p>
        <p v-if="address.address_line2">{{ address.address_line2 }}</p>
        <p>
          {{ address.city }}, {{ address.state }} {{ address.postal_code }}
        </p>
        <p>{{ address.country }}</p>
        <p class="pt-1 text-xs text-zinc-500">{{ address.phone }}</p>
        <p class="text-xs text-zinc-500 capitalize">
          {{ address.address_type }} address
        </p>
      </div>
      <div class="flex flex-col items-end gap-2">
        <span
          v-if="address.is_default"
          class="inline-flex items-center rounded-full bg-zinc-900 text-white px-2 py-0.5 text-xs font-medium"
        >
          Default
        </span>
        <div class="flex items-center gap-2 mt-auto">
          <button
            type="button"
            class="text-xs text-zinc-600 hover:text-zinc-900"
            @click.stop="$emit('edit')"
          >
            Edit
          </button>
          <button
            type="button"
            class="text-xs text-red-600 hover:text-red-800"
            @click.stop="$emit('delete')"
          >
            Delete
          </button>
        </div>
        <button
          v-if="!address.is_default"
          type="button"
          class="text-xs text-zinc-600 hover:text-zinc-900"
          @click.stop="$emit('make-default')"
        >
          Set as default
        </button>
      </div>
    </div>
  </article>
</template>

<script setup lang="ts">
import type { Database } from '~/types/database'

type Address = Database['public']['Tables']['addresses']['Row']

defineProps<{
  address: Address
}>()

defineEmits<{
  (e: 'edit'): void
  (e: 'delete'): void
  (e: 'make-default'): void
}>()
</script>
