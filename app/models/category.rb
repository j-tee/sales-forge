class Category < ApplicationRecord
  belongs_to :store
  has_many :products
end
