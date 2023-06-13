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
  def qty_damaged
    qty = 0
    damages.each do |damaged|
      qty += damaged.quantity;
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
end
