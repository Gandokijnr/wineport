<template>
  <form class="space-y-4" @submit.prevent="onSubmit">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="block text-sm font-medium text-zinc-900 mb-1" for="first_name">First name</label>
        <input
          id="first_name"
          v-model="local.first_name"
          type="text"
          class="input"
          autocomplete="given-name"
        />
      </div>
      <div>
        <label class="block text-sm font-medium text-zinc-900 mb-1" for="last_name">Last name</label>
        <input
          id="last_name"
          v-model="local.last_name"
          type="text"
          class="input"
          autocomplete="family-name"
        />
      </div>
    </div>

    <div>
      <label class="block text-sm font-medium text-zinc-900 mb-1" for="email">Email</label>
      <input
        id="email"
        :value="email"
        type="email"
        class="input bg-zinc-50 text-zinc-500 cursor-not-allowed"
        disabled
      />
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <label class="block text-sm font-medium text-zinc-900 mb-1" for="phone">Phone</label>
        <input
          id="phone"
          v-model="local.phone"
          type="tel"
          class="input"
          autocomplete="tel"
        />
      </div>
      <div>
        <label class="block text-sm font-medium text-zinc-900 mb-1" for="company">Company (optional)</label>
        <input
          id="company"
          v-model="local.company_name"
          type="text"
          class="input"
          autocomplete="organization"
        />
      </div>
    </div>

    <div class="flex items-center justify-end gap-3 pt-2">
      <button type="button" class="btn btn-secondary" @click="$emit('cancel')">
        Cancel
      </button>
      <button type="submit" class="btn btn-primary" :disabled="saving">
        {{ saving ? 'Saving…' : 'Save changes' }}
      </button>
    </div>
  </form>
</template>

<script setup lang="ts">
interface ProfileFormModel {
  first_name: string | null
  last_name: string | null
  phone: string | null
  company_name: string | null
}

const props = defineProps<{
  modelValue: ProfileFormModel
  email: string
  saving: boolean
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: ProfileFormModel): void
  (e: 'submit', value: ProfileFormModel): void
  (e: 'cancel'): void
}>()

const local = reactive<ProfileFormModel>({
  first_name: props.modelValue.first_name,
  last_name: props.modelValue.last_name,
  phone: props.modelValue.phone,
  company_name: props.modelValue.company_name
})

watch(
  () => props.modelValue,
  (value) => {
    local.first_name = value.first_name
    local.last_name = value.last_name
    local.phone = value.phone
    local.company_name = value.company_name
  },
  { deep: true }
)

watch(
  () => local,
  (value) => {
    emit('update:modelValue', { ...value })
  },
  { deep: true }
)

const onSubmit = () => {
  emit('submit', { ...local })
}
</script>
