class Stock < ApplicationRecord
  belongs_to :store
  has_many :products
end