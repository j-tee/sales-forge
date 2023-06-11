# seed.rb

# # Generate stock records
# 15.times do
#   # Select a random store_id
#   store_id = Store.pluck(:id).sample
  
#   # Calculate the stock_date
#   min_days = 15
#   max_days = 45
#   stock_date = Date.today + rand(min_days..max_days).days
  
#   # Generate stock record
#   Stock.create(
#     stock_date: stock_date,
#     store_id: store_id,
#     details: "Sample details"
#   )
# end
# seed.rb

# # Generate category records
# 15.times do
#   # Select a random store_id
#   store_id = Store.pluck(:id).sample
  
#   # Generate category record
#   Category.create(
#     name: Faker::Commerce.unique.department,
#     description: Faker::Lorem.sentence,
#     store_id: store_id
#   )
# end

# seed.rb

# Generate product records for each category
# seed.rb

# Generate product records for each category
Category.all.each do |category|
  500.times do
    # Select a random stock_id
    stock_id = Stock.pluck(:id).sample

    product = Product.new(
      unit_price: Faker::Commerce.price(range: 0..100.0),
      product_name: Faker::Commerce.product_name,
      unit_cost: Faker::Commerce.price(range: 0..50.0),
      country: Faker::Address.country,
      manufacturer: Faker::Company.name,
      mnf_date: Faker::Date.between(from: 2.years.ago, to: Date.today),
      exp_date: Faker::Date.between(from: Date.today, to: 1.year.from_now),
      qty_in_stock: Faker::Number.between(from: 0, to: 1000),
      description: Faker::Lorem.sentence,
      supplier: Faker::Company.name,
      qty_sold: Faker::Number.between(from: 0, to: 500),
      total_expired: Faker::Number.between(from: 0, to: 100),
      qty_stolen: Faker::Number.between(from: 0, to: 50),
      qty_damaged: Faker::Number.between(from: 0, to: 50),
      stock_id: stock_id,
      category_id: category.id
    )
    product.save(validate: false)
  end
end


