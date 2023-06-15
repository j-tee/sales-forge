class Stock < ApplicationRecord
  belongs_to :store
  has_many :products

  def damages
    qty = 0
    products.each do |product|
      qty += product.qty_damaged
    end
    qty
  end

  def expired
    qty = 0
    products.each do |product|
      qty += product.qty_expired
    end
    qty
  end

  def qty_of_product_sold
    qty = 0
    products.each do |product|
      qty += product.qty_of_product_sold
    end
  end

  def total_cost
    total_cost = 0
    products.each do |product|
      total_cost += product.total_cost
    end
    total_cost
  end

  def expected_revenue
    revenue = 0
    products.each do |product|
      revenue += product.expected_revenue
    end
    revenue
  end

  def actual_revenue
    revenue = 0
    products.each do |product|
      revenue += product.actual_revenue
    end
    revenue
  end

  def cost_of_damages
    damages = 0
    products.each do |product|
      damages += product.cost_of_damages
    end
    damages
  end

  def cost_of_expired_products
    expired = 0
    products.each do |product|
      expired += product.cost_of_expired_products
    end
    expired
  end
end