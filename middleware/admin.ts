export default defineNuxtRouteMiddleware(async (to) => {
  const { user, checkAuth } = useAuth()

  if (!user.value) {
    await checkAuth()
  }

  if (!user.value) {
    return navigateTo(`/auth/login?redirect=${encodeURIComponent(to.fullPath)}`)
  }

  const appMetadata = (user.value as any).app_metadata || {}
  const userMetadata = (user.value as any).user_metadata || {}
  const role = (appMetadata.role || userMetadata.role) as string | undefined
  const isAdmin = role === 'admin'

  if (!isAdmin) {
    return navigateTo('/')
  }
})
