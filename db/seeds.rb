# db/seed.rb

puts 'Seeding database...'

# # Get a list of all migration versions
# all_versions = ActiveRecord::MigrationContext.new('db/migrate').get_all_versions

# # Exclude the problematic migration version
# excluded_version = '20230511174738'
# migrated_versions = all_versions.reject { |v| v == excluded_version }

# # Run migrations up to the latest version excluding the problematic migration
# ActiveRecord::MigrationContext.new('db/migrate').migrate(migrated_versions)

# Your seed data and logic go here
# category_ids = Category.pluck(:id)
# stock_ids = Stock.pluck(:id)
# current_date = Date.today
# january_2023 = Date.new(2023, 1, 1)
# april_2023 = Date.new(2023, 4, 30)

# 300.times do
#   category_id = category_ids.sample
#   stock_id = stock_ids.sample
#   mnf_date = rand(january_2023..april_2023)
#   exp_date = rand((current_date + 1)..(current_date + 365))
#   qty_in_stock = rand(1..100)
#   qty_sold = rand(0..qty_in_stock) # Ensure qty_sold is not more than qty_in_stock
#   unit_price = rand(10.0..100.0).round(2)
#   unit_cost = rand(5.0..(unit_price - 1)).round(2) # Ensure unit_cost is less than unit_price
  
#   product = Product.create(
#     unit_price: unit_price,
#     product_name: Faker::Commerce.product_name,
#     unit_cost: unit_cost,
#     country: Faker::Address.country,
#     manufacturer: Faker::Company.name,
#     mnf_date: mnf_date,
#     exp_date: exp_date,
#     qty_in_stock: qty_in_stock,
#     category_id: category_id,
#     description: Faker::Lorem.sentence,
#     supplier: Faker::Company.name,
#     qty_sold: qty_sold,
#     total_expired: rand(0..100),
#     qty_stolen: rand(0..10),
#     qty_damaged: rand(0..10),
#     stock_id: stock_id
#   )
  
#   puts "Created product #{product.id}"
# end
# 20.times do
#     store = Store.order('RANDOM()').first
#     Employee.create(
#       name: Faker::Name.name,
#       email: Faker::Internet.email,
#       phone1: Faker::PhoneNumber.phone_number,
#       phone2: Faker::PhoneNumber.phone_number,
#       store_id: store.id,
#       created_at: Time.current,
#       updated_at: Time.current
#     )
#   end
require 'faker'

# Create 30 customers
30.times do
    store = Store.order('RANDOM()').first
    customer = Customer.create(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      phone: Faker::PhoneNumber.phone_number,
      address: Faker::Address.full_address,
      store_id: store.id,
      created_at: Time.current,
      updated_at: Time.current
    )
  
    # Generate random number of orders for each customer
    rand(1..5).times do
      order = Order.create(
        status: Faker::Lorem.word,
        total: Faker::Commerce.price(range: 10..100),
        customer_id: customer.id,
        employee_id: Employee.order('RANDOM()').first.id,
        stock_id: Stock.order('RANDOM()').first.id,
        created_at: Time.current,
        updated_at: Time.current
      )
  
      # Generate random number of order line items for each order
      rand(1..5).times do
        product = Product.order('RANDOM()').first
        quantity = rand(1..10)
        total_cost = quantity * product.unit_price
  
        OrderLineItem.create(
          quantity: quantity,
          product_id: product.id,
          order_id: order.id,
          total_cost: total_cost,
          created_at: Time.current,
          updated_at: Time.current
        )
      end
    end
  end
