/*
  # LiquidLogistics E-Commerce Database Schema

  ## Overview
  Complete database schema for a modern beverage e-commerce platform supporting both B2C and B2B customers.

  ## New Tables

  ### 1. Categories
    - `id` (uuid, primary key) - Unique category identifier
    - `name` (text) - Category name (e.g., "Wine", "Spirits", "Beer")
    - `slug` (text, unique) - URL-friendly identifier
    - `description` (text) - Category description
    - `image_url` (text) - Category image
    - `parent_id` (uuid, nullable) - For nested categories
    - `sort_order` (integer) - Display order
    - `created_at` (timestamptz) - Creation timestamp

  ### 2. Products
    - `id` (uuid, primary key) - Unique product identifier
    - `category_id` (uuid) - Foreign key to categories
    - `name` (text) - Product name
    - `slug` (text, unique) - URL-friendly identifier
    - `description` (text) - Full product description
    - `short_description` (text) - Brief summary
    - `price` (decimal) - Base price
    - `compare_at_price` (decimal, nullable) - Original price for discounts
    - `cost_price` (decimal) - Cost for margin calculation
    - `sku` (text, unique) - Stock keeping unit
    - `barcode` (text, nullable) - Product barcode
    - `stock_quantity` (integer) - Current inventory
    - `low_stock_threshold` (integer) - Alert threshold
    - `brand` (text) - Product brand
    - `volume` (text) - Volume (e.g., "750ml", "1L")
    - `alcohol_percentage` (decimal, nullable) - ABV
    - `country_of_origin` (text) - Origin country
    - `image_urls` (jsonb) - Array of product images
    - `is_featured` (boolean) - Featured product flag
    - `is_active` (boolean) - Active status
    - `tags` (text[]) - Search tags
    - `created_at` (timestamptz) - Creation timestamp
    - `updated_at` (timestamptz) - Last update timestamp

  ### 3. Customers
    - `id` (uuid, primary key) - Links to auth.users
    - `email` (text, unique) - Customer email
    - `first_name` (text) - First name
    - `last_name` (text) - Last name
    - `phone` (text) - Contact number
    - `customer_type` (text) - 'b2c' or 'b2b'
    - `company_name` (text, nullable) - For B2B customers
    - `tax_id` (text, nullable) - Business tax ID
    - `discount_tier` (text) - Discount level
    - `created_at` (timestamptz) - Registration date
    - `updated_at` (timestamptz) - Last update

  ### 4. Addresses
    - `id` (uuid, primary key) - Unique address identifier
    - `customer_id` (uuid) - Foreign key to customers
    - `address_type` (text) - 'billing' or 'shipping'
    - `is_default` (boolean) - Default address flag
    - `first_name` (text) - Recipient first name
    - `last_name` (text) - Recipient last name
    - `company` (text, nullable) - Company name
    - `address_line1` (text) - Street address
    - `address_line2` (text, nullable) - Apartment, suite, etc.
    - `city` (text) - City
    - `state` (text) - State/Province
    - `postal_code` (text) - ZIP/Postal code
    - `country` (text) - Country
    - `phone` (text) - Contact number
    - `created_at` (timestamptz) - Creation timestamp

  ### 5. Orders
    - `id` (uuid, primary key) - Unique order identifier
    - `order_number` (text, unique) - Human-readable order number
    - `customer_id` (uuid) - Foreign key to customers
    - `status` (text) - Order status
    - `payment_status` (text) - Payment status
    - `subtotal` (decimal) - Items subtotal
    - `tax` (decimal) - Tax amount
    - `shipping_cost` (decimal) - Shipping cost
    - `discount` (decimal) - Discount amount
    - `total` (decimal) - Final total
    - `shipping_address` (jsonb) - Shipping address snapshot
    - `billing_address` (jsonb) - Billing address snapshot
    - `notes` (text, nullable) - Order notes
    - `created_at` (timestamptz) - Order date
    - `updated_at` (timestamptz) - Last update

  ### 6. Order Items
    - `id` (uuid, primary key) - Unique item identifier
    - `order_id` (uuid) - Foreign key to orders
    - `product_id` (uuid) - Foreign key to products
    - `quantity` (integer) - Quantity ordered
    - `unit_price` (decimal) - Price per unit at time of order
    - `subtotal` (decimal) - Line item total
    - `product_snapshot` (jsonb) - Product details snapshot
    - `created_at` (timestamptz) - Creation timestamp

  ### 7. Cart Items
    - `id` (uuid, primary key) - Unique cart item identifier
    - `customer_id` (uuid) - Foreign key to customers
    - `product_id` (uuid) - Foreign key to products
    - `quantity` (integer) - Quantity in cart
    - `created_at` (timestamptz) - Added to cart timestamp
    - `updated_at` (timestamptz) - Last update

  ### 8. Reviews
    - `id` (uuid, primary key) - Unique review identifier
    - `product_id` (uuid) - Foreign key to products
    - `customer_id` (uuid) - Foreign key to customers
    - `rating` (integer) - Rating (1-5)
    - `title` (text) - Review title
    - `comment` (text) - Review text
    - `is_verified_purchase` (boolean) - Verified purchase flag
    - `is_approved` (boolean) - Moderation status
    - `created_at` (timestamptz) - Review date

  ## Security
  - Row Level Security (RLS) enabled on all tables
  - Policies for authenticated users to manage their own data
  - Admin-only policies for sensitive operations
  - Public read access for products and categories
*/

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text,
  image_url text,
  parent_id uuid REFERENCES categories(id) ON DELETE SET NULL,
  sort_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Categories are viewable by everyone"
  ON categories FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Only admins can insert categories"
  ON categories FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Only admins can update categories"
  ON categories FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin')
  WITH CHECK (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Only admins can delete categories"
  ON categories FOR DELETE
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin');

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES categories(id) ON DELETE SET NULL,
  name text NOT NULL,
  slug text UNIQUE NOT NULL,
  description text,
  short_description text,
  price decimal(10,2) NOT NULL,
  compare_at_price decimal(10,2),
  cost_price decimal(10,2),
  sku text UNIQUE NOT NULL,
  barcode text,
  stock_quantity integer DEFAULT 0,
  low_stock_threshold integer DEFAULT 10,
  brand text,
  volume text,
  alcohol_percentage decimal(4,2),
  country_of_origin text,
  image_urls jsonb DEFAULT '[]'::jsonb,
  is_featured boolean DEFAULT false,
  is_active boolean DEFAULT true,
  tags text[] DEFAULT '{}',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Products are viewable by everyone"
  ON products FOR SELECT
  TO public
  USING (is_active = true);

CREATE POLICY "Admins can view all products"
  ON products FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Only admins can insert products"
  ON products FOR INSERT
  TO authenticated
  WITH CHECK (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Only admins can update products"
  ON products FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin')
  WITH CHECK (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Only admins can delete products"
  ON products FOR DELETE
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin');

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text UNIQUE NOT NULL,
  first_name text,
  last_name text,
  phone text,
  customer_type text DEFAULT 'b2c' CHECK (customer_type IN ('b2c', 'b2b')),
  company_name text,
  tax_id text,
  discount_tier text DEFAULT 'standard',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can view own data"
  ON customers FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Customers can update own data"
  ON customers FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can view all customers"
  ON customers FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Anyone can insert customer profile"
  ON customers FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Create addresses table
CREATE TABLE IF NOT EXISTS addresses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES customers(id) ON DELETE CASCADE NOT NULL,
  address_type text NOT NULL CHECK (address_type IN ('billing', 'shipping')),
  is_default boolean DEFAULT false,
  first_name text NOT NULL,
  last_name text NOT NULL,
  company text,
  address_line1 text NOT NULL,
  address_line2 text,
  city text NOT NULL,
  state text NOT NULL,
  postal_code text NOT NULL,
  country text NOT NULL,
  phone text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can view own addresses"
  ON addresses FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

CREATE POLICY "Customers can insert own addresses"
  ON addresses FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Customers can update own addresses"
  ON addresses FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid())
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Customers can delete own addresses"
  ON addresses FOR DELETE
  TO authenticated
  USING (customer_id = auth.uid());

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number text UNIQUE NOT NULL,
  customer_id uuid REFERENCES customers(id) ON DELETE SET NULL NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
  payment_status text DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
  subtotal decimal(10,2) NOT NULL,
  tax decimal(10,2) DEFAULT 0,
  shipping_cost decimal(10,2) DEFAULT 0,
  discount decimal(10,2) DEFAULT 0,
  total decimal(10,2) NOT NULL,
  shipping_address jsonb NOT NULL,
  billing_address jsonb NOT NULL,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can view own orders"
  ON orders FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

CREATE POLICY "Customers can create orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Admins can view all orders"
  ON orders FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin');

CREATE POLICY "Admins can update orders"
  ON orders FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin')
  WITH CHECK (auth.jwt()->>'role' = 'admin');

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL NOT NULL,
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price decimal(10,2) NOT NULL,
  subtotal decimal(10,2) NOT NULL,
  product_snapshot jsonb NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can view own order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );

CREATE POLICY "Customers can create order items"
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.customer_id = auth.uid()
    )
  );

CREATE POLICY "Admins can view all order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin');

-- Create cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES customers(id) ON DELETE CASCADE NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE CASCADE NOT NULL,
  quantity integer NOT NULL CHECK (quantity > 0),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(customer_id, product_id)
);

ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can view own cart"
  ON cart_items FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

CREATE POLICY "Customers can insert into own cart"
  ON cart_items FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Customers can update own cart"
  ON cart_items FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid())
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Customers can delete from own cart"
  ON cart_items FOR DELETE
  TO authenticated
  USING (customer_id = auth.uid());

-- Create reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid REFERENCES products(id) ON DELETE CASCADE NOT NULL,
  customer_id uuid REFERENCES customers(id) ON DELETE CASCADE NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title text,
  comment text,
  is_verified_purchase boolean DEFAULT false,
  is_approved boolean DEFAULT false,
  created_at timestamptz DEFAULT now(),
  UNIQUE(product_id, customer_id)
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Approved reviews are viewable by everyone"
  ON reviews FOR SELECT
  TO public
  USING (is_approved = true);

CREATE POLICY "Customers can view own reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (customer_id = auth.uid());

CREATE POLICY "Customers can create reviews"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Customers can update own reviews"
  ON reviews FOR UPDATE
  TO authenticated
  USING (customer_id = auth.uid() AND is_approved = false)
  WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Admins can approve reviews"
  ON reviews FOR UPDATE
  TO authenticated
  USING (auth.jwt()->>'role' = 'admin')
  WITH CHECK (auth.jwt()->>'role' = 'admin');

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_is_featured ON products(is_featured);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_customer ON cart_items(customer_id);
CREATE INDEX IF NOT EXISTS idx_reviews_product ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_addresses_customer ON addresses(customer_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at
  BEFORE UPDATE ON customers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cart_items_updated_at
  BEFORE UPDATE ON cart_items
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
