class StoreDiscount < ApplicationRecord
  belongs_to :store
  belongs_to :discount
end
