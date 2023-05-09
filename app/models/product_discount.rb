class ProductDiscount < ApplicationRecord
  belongs_to :product
  belongs_to :discount
end
