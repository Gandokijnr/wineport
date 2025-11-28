<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>

<script setup lang="ts">
const { checkAuth } = useAuth()
const { fetchCart } = useCart()

onMounted(async () => {
  await checkAuth()
  await fetchCart()
})
</script>
