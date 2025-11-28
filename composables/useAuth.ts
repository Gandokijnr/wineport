export const useAuth = () => {
  const supabase = useSupabase()
  const user = useState('user', () => null)
  const loading = useState('auth-loading', () => true)

  const checkAuth = async () => {
    loading.value = true
    try {
      const { data: { user: authUser } } = await supabase.auth.getUser()
      user.value = authUser
    } catch (error) {
      console.error('Error checking auth:', error)
      user.value = null
    } finally {
      loading.value = false
    }
  }

  const signUp = async (email: string, password: string, userData: any = {}) => {
    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: userData
        }
      })

      if (error) throw error

      if (data.user) {
        const { error: customerError } = await supabase
          .from('customers')
          .insert({
            id: data.user.id,
            email: data.user.email!,
            first_name: userData.first_name || null,
            last_name: userData.last_name || null,
            customer_type: userData.customer_type || 'b2c'
          })

        if (customerError) throw customerError
      }

      return { success: true, data }
    } catch (error: any) {
      console.error('Error signing up:', error)
      return { success: false, error: error.message }
    }
  }

  const signIn = async (email: string, password: string) => {
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      })

      if (error) throw error

      user.value = data.user
      return { success: true, data }
    } catch (error: any) {
      console.error('Error signing in:', error)
      return { success: false, error: error.message }
    }
  }

  const signOut = async () => {
    try {
      const { error } = await supabase.auth.signOut()
      if (error) throw error

      user.value = null
      return { success: true }
    } catch (error: any) {
      console.error('Error signing out:', error)
      return { success: false, error: error.message }
    }
  }

  return {
    user,
    loading,
    checkAuth,
    signUp,
    signIn,
    signOut
  }
}
