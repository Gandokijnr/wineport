import type { Database } from '~/types/database'

type CartItem = Database['public']['Tables']['cart_items']['Row'] & {
  product?: Database['public']['Tables']['products']['Row']
}

export const useCart = () => {
  const supabase = useSupabase()
  const cartItems = useState<CartItem[]>('cart-items', () => [])
  const loading = useState('cart-loading', () => false)

  const cartCount = computed(() => {
    return cartItems.value.reduce((total, item) => total + item.quantity, 0)
  })

  const cartTotal = computed(() => {
    return cartItems.value.reduce((total, item) => {
      const price = item.product?.price || 0
      return total + (price * item.quantity)
    }, 0)
  })

  const fetchCart = async () => {
    loading.value = true
    try {
      const { data: { user } } = await supabase.auth.getUser()

      if (!user) {
        cartItems.value = []
        return
      }

      const { data, error } = await supabase
        .from('cart_items')
        .select(`
          *,
          product:products(*)
        `)
        .eq('customer_id', user.id)

      if (error) throw error
      cartItems.value = data || []
    } catch (error) {
      console.error('Error fetching cart:', error)
      cartItems.value = []
    } finally {
      loading.value = false
    }
  }

  const addToCart = async (productId: string, quantity: number = 1) => {
    try {
      const { data: { user } } = await supabase.auth.getUser()

      if (!user) {
        throw new Error('Please sign in to add items to cart')
      }

      const existingItem = cartItems.value.find(item => item.product_id === productId)

      if (existingItem) {
        const { error } = await supabase
          .from('cart_items')
          .update({ quantity: existingItem.quantity + quantity })
          .eq('id', existingItem.id)

        if (error) throw error
      } else {
        const { error } = await supabase
          .from('cart_items')
          .insert({
            customer_id: user.id,
            product_id: productId,
            quantity
          })

        if (error) throw error
      }

      await fetchCart()
      return { success: true }
    } catch (error: any) {
      console.error('Error adding to cart:', error)
      return { success: false, error: error.message }
    }
  }

  const updateQuantity = async (itemId: string, quantity: number) => {
    if (quantity <= 0) {
      return removeFromCart(itemId)
    }

    try {
      const { error } = await supabase
        .from('cart_items')
        .update({ quantity })
        .eq('id', itemId)

      if (error) throw error

      await fetchCart()
      return { success: true }
    } catch (error: any) {
      console.error('Error updating cart:', error)
      return { success: false, error: error.message }
    }
  }

  const removeFromCart = async (itemId: string) => {
    try {
      const { error } = await supabase
        .from('cart_items')
        .delete()
        .eq('id', itemId)

      if (error) throw error

      await fetchCart()
      return { success: true }
    } catch (error: any) {
      console.error('Error removing from cart:', error)
      return { success: false, error: error.message }
    }
  }

  const clearCart = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()

      if (!user) return { success: false }

      const { error } = await supabase
        .from('cart_items')
        .delete()
        .eq('customer_id', user.id)

      if (error) throw error

      cartItems.value = []
      return { success: true }
    } catch (error: any) {
      console.error('Error clearing cart:', error)
      return { success: false, error: error.message }
    }
  }

  return {
    cartItems,
    cartCount,
    cartTotal,
    loading,
    fetchCart,
    addToCart,
    updateQuantity,
    removeFromCart,
    clearCart
  }
}
