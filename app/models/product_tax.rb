class ProductTax < ApplicationRecord
  self.primary_key = false

  belongs_to :product
  belongs_to :tax
end
