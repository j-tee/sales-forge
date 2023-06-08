class Customer < ApplicationRecord
  belongs_to :store
  has_many :orders, class_name: "Order", foreign_key: "customer_id"
end
