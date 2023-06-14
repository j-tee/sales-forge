class Damage < ApplicationRecord
  belongs_to :product

  def product_name
    product.product_name
  end
end
