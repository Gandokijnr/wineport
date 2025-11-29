<template>
  <div class="min-h-screen bg-zinc-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <h1 class="text-4xl font-bold text-zinc-900 mb-8">Checkout</h1>

      <div v-if="!user" class="card text-center py-12">
        <Lock :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">Sign in to continue</h2>
        <p class="text-zinc-600 mb-6">You need to be signed in to place an order</p>
        <NuxtLink to="/auth/login" class="btn btn-primary">
          Sign In
        </NuxtLink>
      </div>

      <div v-else-if="cartItems.length === 0" class="card text-center py-12">
        <ShoppingCart :size="48" class="mx-auto text-zinc-400 mb-4" />
        <h2 class="text-2xl font-semibold text-zinc-900 mb-2">Your cart is empty</h2>
        <p class="text-zinc-600 mb-6">Add some products before checking out</p>
        <NuxtLink to="/products" class="btn btn-primary">
          Browse Products
        </NuxtLink>
      </div>

      <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div class="lg:col-span-2 space-y-6">
          <div class="card">
            <h2 class="text-xl font-bold text-zinc-900 mb-4">Shipping Information</h2>
            <form @submit.prevent class="space-y-4">
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label for="firstName" class="block text-sm font-medium text-zinc-900 mb-1">
                    First Name *
                  </label>
                  <input
                    id="firstName"
                    v-model="shippingForm.first_name"
                    type="text"
                    required
                    class="input"
                  />
                </div>
                <div>
                  <label for="lastName" class="block text-sm font-medium text-zinc-900 mb-1">
                    Last Name *
                  </label>
                  <input
                    id="lastName"
                    v-model="shippingForm.last_name"
                    type="text"
                    required
                    class="input"
                  />
                </div>
              </div>

              <div>
                <label for="company" class="block text-sm font-medium text-zinc-900 mb-1">
                  Company (Optional)
                </label>
                <input
                  id="company"
                  v-model="shippingForm.company"
                  type="text"
                  class="input"
                />
              </div>

              <div>
                <label for="address1" class="block text-sm font-medium text-zinc-900 mb-1">
                  Address Line 1 *
                </label>
                <input
                  id="address1"
                  v-model="shippingForm.address_line1"
                  type="text"
                  required
                  class="input"
                />
              </div>

              <div>
                <label for="address2" class="block text-sm font-medium text-zinc-900 mb-1">
                  Address Line 2 (Optional)
                </label>
                <input
                  id="address2"
                  v-model="shippingForm.address_line2"
                  type="text"
                  class="input"
                />
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                  <label for="city" class="block text-sm font-medium text-zinc-900 mb-1">
                    City *
                  </label>
                  <input
                    id="city"
                    v-model="shippingForm.city"
                    type="text"
                    required
                    class="input"
                  />
                </div>
                <div>
                  <label for="state" class="block text-sm font-medium text-zinc-900 mb-1">
                    State *
                  </label>
                  <input
                    id="state"
                    v-model="shippingForm.state"
                    type="text"
                    required
                    class="input"
                  />
                </div>
                <div>
                  <label for="postalCode" class="block text-sm font-medium text-zinc-900 mb-1">
                    Postal Code *
                  </label>
                  <input
                    id="postalCode"
                    v-model="shippingForm.postal_code"
                    type="text"
                    required
                    class="input"
                  />
                </div>
              </div>

              <div>
                <label for="country" class="block text-sm font-medium text-zinc-900 mb-1">
                  Country *
                </label>
                <input
                  id="country"
                  v-model="shippingForm.country"
                  type="text"
                  required
                  class="input"
                />
              </div>

              <div>
                <label for="phone" class="block text-sm font-medium text-zinc-900 mb-1">
                  Phone *
                </label>
                <input
                  id="phone"
                  v-model="shippingForm.phone"
                  type="tel"
                  required
                  class="input"
                />
              </div>
            </form>
          </div>

          <div class="card">
            <div class="flex items-center justify-between mb-4">
              <h2 class="text-xl font-bold text-zinc-900">Billing Information</h2>
              <label class="flex items-center gap-2 cursor-pointer">
                <input
                  v-model="sameAsShipping"
                  type="checkbox"
                  class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
                />
                <span class="text-sm text-zinc-700">Same as shipping</span>
              </label>
            </div>

            <form v-if="!sameAsShipping" @submit.prevent class="space-y-4">
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label for="billFirstName" class="block text-sm font-medium text-zinc-900 mb-1">
                    First Name *
                  </label>
                  <input
                    id="billFirstName"
                    v-model="billingForm.first_name"
                    type="text"
                    required
                    class="input"
                  />
                </div>
                <div>
                  <label for="billLastName" class="block text-sm font-medium text-zinc-900 mb-1">
                    Last Name *
                  </label>
                  <input
                    id="billLastName"
                    v-model="billingForm.last_name"
                    type="text"
                    required
                    class="input"
                  />
                </div>
              </div>

              <div>
                <label for="billAddress1" class="block text-sm font-medium text-zinc-900 mb-1">
                  Address Line 1 *
                </label>
                <input
                  id="billAddress1"
                  v-model="billingForm.address_line1"
                  type="text"
                  required
                  class="input"
                />
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                  <label for="billCity" class="block text-sm font-medium text-zinc-900 mb-1">
                    City *
                  </label>
                  <input
                    id="billCity"
                    v-model="billingForm.city"
                    type="text"
                    required
                    class="input"
                  />
                </div>
                <div>
                  <label for="billState" class="block text-sm font-medium text-zinc-900 mb-1">
                    State *
                  </label>
                  <input
                    id="billState"
                    v-model="billingForm.state"
                    type="text"
                    required
                    class="input"
                  />
                </div>
                <div>
                  <label for="billPostalCode" class="block text-sm font-medium text-zinc-900 mb-1">
                    Postal Code *
                  </label>
                  <input
                    id="billPostalCode"
                    v-model="billingForm.postal_code"
                    type="text"
                    required
                    class="input"
                  />
                </div>
              </div>
            </form>
          </div>

          <div class="card">
            <h2 class="text-xl font-bold text-zinc-900 mb-4">Order Notes</h2>
            <textarea
              v-model="orderNotes"
              rows="4"
              placeholder="Add any special instructions for your order..."
              class="input resize-none"
            ></textarea>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="card sticky top-24">
            <h2 class="text-xl font-bold text-zinc-900 mb-4">Order Summary</h2>

            <div class="space-y-3 mb-6 max-h-64 overflow-y-auto">
              <div
                v-for="item in cartItems"
                :key="item.id"
                class="flex items-center gap-3 text-sm"
              >
                <div class="w-12 h-12 bg-zinc-100 rounded flex-shrink-0">
                  <img
                    v-if="item.product?.image_urls?.[0]"
                    :src="item.product.image_urls[0]"
                    :alt="item.product?.name"
                    class="w-full h-full object-cover rounded"
                  />
                </div>
                <div class="flex-1 min-w-0">
                  <p class="font-medium text-zinc-900 truncate">{{ item.product?.name }}</p>
                  <p class="text-zinc-600">Qty: {{ item.quantity }}</p>
                </div>
                <p class="font-medium text-zinc-900">
                  ${{ ((item.product?.price || 0) * item.quantity).toFixed(2) }}
                </p>
              </div>
            </div>

            <div class="space-y-3 mb-6 pt-6 border-t border-zinc-200">
              <div class="flex items-center justify-between text-sm">
                <span class="text-zinc-600">Subtotal</span>
                <span class="font-medium text-zinc-900">${subtotal.toFixed(2)}</span>
              </div>
              <div class="flex items-center justify-between text-sm">
                <span class="text-zinc-600">Shipping</span>
                <span class="font-medium text-zinc-900">${shipping.toFixed(2)}</span>
              </div>
              <div class="flex items-center justify-between text-sm">
                <span class="text-zinc-600">Tax ({{ taxRate * 100 }}%)</span>
                <span class="font-medium text-zinc-900">${tax.toFixed(2)}</span>
              </div>
            </div>

            <div class="pt-6 border-t border-zinc-200 mb-6">
              <div class="flex items-center justify-between text-lg">
                <span class="font-semibold text-zinc-900">Total</span>
                <span class="font-bold text-zinc-900">${total.toFixed(2)}</span>
              </div>
            </div>

            <button
              @click="placeOrder"
              :disabled="placingOrder || !isFormValid"
              class="btn btn-primary w-full py-3 disabled:opacity-50"
            >
              <span v-if="!placingOrder">Place Order</span>
              <span v-else>Processing...</span>
            </button>

            <p class="text-xs text-zinc-600 text-center mt-4">
              By placing your order, you agree to our terms and conditions.
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ShoppingCart, Lock } from 'lucide-vue-next'

const supabase = useSupabase()
const { cartItems, cartTotal, fetchCart, clearCart } = useCart()
const user = ref(null)

const shippingForm = ref({
  first_name: '',
  last_name: '',
  company: '',
  address_line1: '',
  address_line2: '',
  city: '',
  state: '',
  postal_code: '',
  country: 'USA',
  phone: ''
})

const billingForm = ref({
  first_name: '',
  last_name: '',
  company: '',
  address_line1: '',
  address_line2: '',
  city: '',
  state: '',
  postal_code: '',
  country: 'USA',
  phone: ''
})

const sameAsShipping = ref(true)
const orderNotes = ref('')
const placingOrder = ref(false)

const taxRate = 0.08
const shippingCost = 15

const subtotal = computed(() => cartTotal.value)
const shipping = computed(() => shippingCost)
const tax = computed(() => subtotal.value * taxRate)
const total = computed(() => subtotal.value + shipping.value + tax.value)

const isFormValid = computed(() => {
  const shipping = shippingForm.value
  return (
    shipping.first_name &&
    shipping.last_name &&
    shipping.address_line1 &&
    shipping.city &&
    shipping.state &&
    shipping.postal_code &&
    shipping.country &&
    shipping.phone
  )
})

const generateOrderNumber = () => {
  const timestamp = Date.now().toString(36).toUpperCase()
  const random = Math.random().toString(36).substring(2, 6).toUpperCase()
  return `LL-${timestamp}-${random}`
}

const placeOrder = async () => {
  if (!user.value || !isFormValid.value) return

  placingOrder.value = true

  try {
    const shippingAddress = { ...shippingForm.value }
    const billingAddress = sameAsShipping.value ? shippingAddress : { ...billingForm.value }

    const orderNumber = generateOrderNumber()

    const { data: order, error: orderError } = await supabase
      .from('orders')
      .insert({
        order_number: orderNumber,
        customer_id: user.value.id,
        status: 'pending',
        payment_status: 'pending',
        subtotal: subtotal.value,
        tax: tax.value,
        shipping_cost: shipping.value,
        discount: 0,
        total: total.value,
        shipping_address: shippingAddress,
        billing_address: billingAddress,
        notes: orderNotes.value || null
      })
      .select()
      .single()

    if (orderError) throw orderError

    const orderItems = cartItems.value.map(item => ({
      order_id: order.id,
      product_id: item.product_id,
      quantity: item.quantity,
      unit_price: item.product?.price || 0,
      subtotal: (item.product?.price || 0) * item.quantity,
      product_snapshot: item.product
    }))

    const { error: itemsError } = await supabase
      .from('order_items')
      .insert(orderItems)

    if (itemsError) throw itemsError

    await clearCart()

    navigateTo(`/orders/${order.id}`)
  } catch (error) {
    console.error('Error placing order:', error)
    alert('Failed to place order. Please try again.')
  } finally {
    placingOrder.value = false
  }
}

onMounted(async () => {
  const { data: { user: authUser } } = await supabase.auth.getUser()
  user.value = authUser

  if (authUser) {
    await fetchCart()
  }
})

useHead({
  title: 'Checkout - Flux',
  meta: [
    {
      name: 'description',
      content: 'Complete your order'
    }
  ]
})
</script>
