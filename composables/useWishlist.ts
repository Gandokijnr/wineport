import { watch } from 'vue'

export const useWishlist = () => {
  const wishlistIds = useState<string[]>('wishlist-ids', () => [])

  if (process.client) {
    if (wishlistIds.value.length === 0) {
      try {
        const stored = window.localStorage.getItem('flux-wishlist-ids')
        if (stored) {
          const parsed = JSON.parse(stored)
          if (Array.isArray(parsed)) {
            wishlistIds.value = parsed
          }
        }
      } catch (error) {
        console.error('Error reading wishlist from localStorage:', error)
      }
    }

    watch(
      wishlistIds,
      value => {
        try {
          window.localStorage.setItem('flux-wishlist-ids', JSON.stringify(value))
        } catch (error) {
          console.error('Error writing wishlist to localStorage:', error)
        }
      },
      { deep: true }
    )
  }

  const addToWishlist = (productId: string) => {
    if (!wishlistIds.value.includes(productId)) {
      wishlistIds.value.push(productId)
    }
  }

  const removeFromWishlist = (productId: string) => {
    wishlistIds.value = wishlistIds.value.filter(id => id !== productId)
  }

  const toggleWishlist = (productId: string) => {
    if (wishlistIds.value.includes(productId)) {
      removeFromWishlist(productId)
    } else {
      addToWishlist(productId)
    }
  }

  return {
    wishlistIds,
    addToWishlist,
    removeFromWishlist,
    toggleWishlist
  }
}
