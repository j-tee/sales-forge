class Discount < ApplicationRecord
    has_and_belongs_to_many :products, join_table: :product_discounts
    has_many :store_discounts
    has_many :stores, through: :store_discounts
  
    def get_discount_value
      self.discount_value
    end
  
    def get_discount_rate
      self.percentage.to_f / 100
    end
  
    def get_product_name
      self.product.product_name
    end
  
    def get_discount_name
      self.discount.name
    end
  
    def current
      self.start_date <= DateTime.now && DateTime.now <= self.end_date ? true : false
    end
  end
  