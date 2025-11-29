export interface Database {
  public: {
    Tables: {
      categories: {
        Row: {
          id: string
          name: string
          slug: string
          description: string | null
          image_url: string | null
          parent_id: string | null
          sort_order: number
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          slug: string
          description?: string | null
          image_url?: string | null
          parent_id?: string | null
          sort_order?: number
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          slug?: string
          description?: string | null
          image_url?: string | null
          parent_id?: string | null
          sort_order?: number
          created_at?: string
        }
      }
      products: {
        Row: {
          id: string
          category_id: string | null
          name: string
          slug: string
          description: string | null
          short_description: string | null
          price: number
          compare_at_price: number | null
          cost_price: number | null
          sku: string
          barcode: string | null
          stock_quantity: number
          low_stock_threshold: number
          brand: string | null
          volume: string | null
          alcohol_percentage: number | null
          country_of_origin: string | null
          image_urls: string[]
          is_featured: boolean
          is_active: boolean
          tags: string[]
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          category_id?: string | null
          name: string
          slug: string
          description?: string | null
          short_description?: string | null
          price: number
          compare_at_price?: number | null
          cost_price?: number | null
          sku: string
          barcode?: string | null
          stock_quantity?: number
          low_stock_threshold?: number
          brand?: string | null
          volume?: string | null
          alcohol_percentage?: number | null
          country_of_origin?: string | null
          image_urls?: string[]
          is_featured?: boolean
          is_active?: boolean
          tags?: string[]
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          category_id?: string | null
          name?: string
          slug?: string
          description?: string | null
          short_description?: string | null
          price?: number
          compare_at_price?: number | null
          cost_price?: number | null
          sku?: string
          barcode?: string | null
          stock_quantity?: number
          low_stock_threshold?: number
          brand?: string | null
          volume?: string | null
          alcohol_percentage?: number | null
          country_of_origin?: string | null
          image_urls?: string[]
          is_featured?: boolean
          is_active?: boolean
          tags?: string[]
          created_at?: string
          updated_at?: string
        }
      }
      customers: {
        Row: {
          id: string
          email: string
          first_name: string | null
          last_name: string | null
          phone: string | null
          customer_type: 'b2c' | 'b2b'
          company_name: string | null
          tax_id: string | null
          discount_tier: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          first_name?: string | null
          last_name?: string | null
          phone?: string | null
          customer_type?: 'b2c' | 'b2b'
          company_name?: string | null
          tax_id?: string | null
          discount_tier?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          first_name?: string | null
          last_name?: string | null
          phone?: string | null
          customer_type?: 'b2c' | 'b2b'
          company_name?: string | null
          tax_id?: string | null
          discount_tier?: string
          created_at?: string
          updated_at?: string
        }
      }
      addresses: {
        Row: {
          id: string
          customer_id: string
          address_type: 'billing' | 'shipping'
          is_default: boolean
          first_name: string
          last_name: string
          company: string | null
          address_line1: string
          address_line2: string | null
          city: string
          state: string
          postal_code: string
          country: string
          phone: string
          created_at: string
        }
        Insert: {
          id?: string
          customer_id: string
          address_type: 'billing' | 'shipping'
          is_default?: boolean
          first_name: string
          last_name: string
          company?: string | null
          address_line1: string
          address_line2?: string | null
          city: string
          state: string
          postal_code: string
          country: string
          phone: string
          created_at?: string
        }
        Update: {
          id?: string
          customer_id?: string
          address_type?: 'billing' | 'shipping'
          is_default?: boolean
          first_name?: string
          last_name?: string
          company?: string | null
          address_line1?: string
          address_line2?: string | null
          city?: string
          state?: string
          postal_code?: string
          country?: string
          phone?: string
          created_at?: string
        }
      }
      orders: {
        Row: {
          id: string
          order_number: string
          customer_id: string
          status: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
          payment_status: 'pending' | 'paid' | 'failed' | 'refunded'
          subtotal: number
          tax: number
          shipping_cost: number
          discount: number
          total: number
          shipping_address: any
          billing_address: any
          notes: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          order_number: string
          customer_id: string
          status?: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
          payment_status?: 'pending' | 'paid' | 'failed' | 'refunded'
          subtotal: number
          tax?: number
          shipping_cost?: number
          discount?: number
          total: number
          shipping_address: any
          billing_address: any
          notes?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          order_number?: string
          customer_id?: string
          status?: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
          payment_status?: 'pending' | 'paid' | 'failed' | 'refunded'
          subtotal?: number
          tax?: number
          shipping_cost?: number
          discount?: number
          total?: number
          shipping_address?: any
          billing_address?: any
          notes?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      order_items: {
        Row: {
          id: string
          order_id: string
          product_id: string
          quantity: number
          unit_price: number
          subtotal: number
          product_snapshot: any
          created_at: string
        }
        Insert: {
          id?: string
          order_id: string
          product_id: string
          quantity: number
          unit_price: number
          subtotal: number
          product_snapshot: any
          created_at?: string
        }
        Update: {
          id?: string
          order_id?: string
          product_id?: string
          quantity?: number
          unit_price?: number
          subtotal?: number
          product_snapshot?: any
          created_at?: string
        }
      }
      order_status_events: {
        Row: {
          id: string
          order_id: string
          status: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
          note: string | null
          created_at: string
        }
        Insert: {
          id?: string
          order_id: string
          status: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
          note?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          order_id?: string
          status?: 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
          note?: string | null
          created_at?: string
        }
      }
      cart_items: {
        Row: {
          id: string
          customer_id: string
          product_id: string
          quantity: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          customer_id: string
          product_id: string
          quantity: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          customer_id?: string
          product_id?: string
          quantity?: number
          created_at?: string
          updated_at?: string
        }
      }
      reviews: {
        Row: {
          id: string
          product_id: string
          customer_id: string
          rating: number
          title: string | null
          comment: string | null
          is_verified_purchase: boolean
          is_approved: boolean
          created_at: string
        }
        Insert: {
          id?: string
          product_id: string
          customer_id: string
          rating: number
          title?: string | null
          comment?: string | null
          is_verified_purchase?: boolean
          is_approved?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          product_id?: string
          customer_id?: string
          rating?: number
          title?: string | null
          comment?: string | null
          is_verified_purchase?: boolean
          is_approved?: boolean
          created_at?: string
        }
      }
      blog_posts: {
        Row: {
          id: string
          title: string
          slug: string
          excerpt: string | null
          content: string | null
          cover_image_url: string | null
          tags: string[]
          status: 'draft' | 'published'
          published_at: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          title: string
          slug: string
          excerpt?: string | null
          content?: string | null
          cover_image_url?: string | null
          tags?: string[]
          status?: 'draft' | 'published'
          published_at?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          title?: string
          slug?: string
          excerpt?: string | null
          content?: string | null
          cover_image_url?: string | null
          tags?: string[]
          status?: 'draft' | 'published'
          published_at?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      testimonials: {
        Row: {
          id: string
          author_name: string
          author_title: string | null
          quote: string
          rating: number | null
          is_featured: boolean
          is_approved: boolean
          created_at: string
        }
        Insert: {
          id?: string
          author_name: string
          author_title?: string | null
          quote: string
          rating?: number | null
          is_featured?: boolean
          is_approved?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          author_name?: string
          author_title?: string | null
          quote?: string
          rating?: number | null
          is_featured?: boolean
          is_approved?: boolean
          created_at?: string
        }
      }
    }
  }
}
