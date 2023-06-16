class Product < ApplicationRecord
  has_and_belongs_to_many :taxes, join_table: :product_taxes
  has_and_belongs_to_many :discounts, join_table: :product_discounts
  belongs_to :stock
  belongs_to :category
  has_many :tags
  has_many :order_line_items
  has_one_attached :picture
  has_many :damages
  def checked?
    false
  end

  def qty_expired
    qty = 0
    qty = qty_in_stock - qty_of_product_sold - qty_damaged if exp_date.present? && exp_date < Date.today
    qty
  end
  

  def qty_damaged
    qty = 0
    damages.each do |damaged|
      qty += damaged.quantity
    end
    qty
  end

  def qty_of_product_sold
    qty = 0
    order_line_items.each do |item|
      qty += item.quantity
    end
    qty
  end

  def cost_of_quantity_sold
    qty_of_product_sold * unit_cost
  end

  def total_cost
    qty_in_stock * unit_cost
  end

  def expected_revenue
    qty_in_stock * unit_price
  end

  def actual_revenue
    qty_of_product_sold * unit_price
  end

  def cost_of_damages
    unit_cost * qty_damaged
  end

  def cost_of_expired_products
    qty_expired * unit_cost
  end

  def expected_balance
    expected_revenue - total_cost
  end

  def bad_debt
    cost_of_damages + cost_of_expired_products
  end
end
