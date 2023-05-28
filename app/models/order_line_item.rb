class OrderLineItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  # Define the default number of items per page
  paginates_per 10

  def calc_qty
    self.quantity + 1
  end

  def calc_total_cost
    total_cost = 0
    total_cost = self.quantity * self.product.unit_price
    total_cost
  end

  def calc_total_discount_value
    store_discount_value = 0
    store_discounts = StoreDiscount.where(store_id: self.order.stock.store_id)
    store_discounts.each do |store_discount|
      store_discount_value += store_discount.discount.discount_value
    end


    store_rate_value = 0
    store_discounts.each do |store_discount|
      store_rate_value += store_discount.discount.get_discount_rate * calc_total_cost.to_f
    end

    product_discount_value = 0
    self.product.discounts.each do |discount|
      if discount.current
        product_discount_value += discount.get_discount_value
      end
    end
    

    product_rate_value = 0
    self.product.discounts.each do |discount|
      if discount.current
      product_rate_value += discount.get_discount_rate * calc_total_cost
      end
    end

    product_discount_value + product_rate_value + store_discount_value + store_rate_value
  end

  def calc_total_tax
    total_tax = 0
    self.product.taxes.each do |tax|
      total_tax += tax.get_tax_rate * calc_total_cost
      p "=====tax: #{tax.name}"
      # p "====total_tax += tax.get_tax_rate * calc_total_cost=======#{total_tax}=#{tax.name}:#{tax.get_tax_rate}*#{calc_total_cost}"
    end
    total_tax
  end

  def calc_amount_payable
    (calc_total_cost - calc_total_discount_value) + calc_total_tax
  end
  
end
