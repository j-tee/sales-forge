class Product < ApplicationRecord
  has_and_belongs_to_many :taxes, join_table: :product_taxes
  has_and_belongs_to_many :discounts, join_table: :product_discounts
  belongs_to :stock
  belongs_to :category
  has_many :tags
  has_many :order_line_items
  has_one_attached :picture
  def checked?
    false
  end

end
