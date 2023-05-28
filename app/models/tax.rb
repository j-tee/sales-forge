class Tax < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :product_taxes
    belongs_to :store

    def get_tax_rate
      self.rate / 100
    end
    
  end