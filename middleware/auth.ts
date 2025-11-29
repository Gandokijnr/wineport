export default defineNuxtRouteMiddleware(async (to) => {
  const { user, checkAuth } = useAuth()

  if (!user.value) {
    await checkAuth()
  }

  if (!user.value) {
    return navigateTo(`/auth/login?redirect=${encodeURIComponent(to.fullPath)}`)
  }
})
