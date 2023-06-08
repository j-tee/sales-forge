class Order < ApplicationRecord
  belongs_to :stock
  belongs_to :customer
  belongs_to :employee
  has_many :order_line_items
  has_many :products, through: :order_line_items
  has_many :payments

  def customer_name
    self.customer.name
  end

  def employee_name
    self.employee.name
  end

  def get_total_payment
    total_payment = 0
    self.payments.each do |payment|
      total_payment += payment.amount
    end
    total_payment
  end

  def total_cost
    amt = 0
    self.order_line_items.each do |item|
      amt += item.calc_total_cost
    end
    amt
  end

  def total_tax 
    tax = 0
    self.order_line_items.each do |item|
      tax += item.calc_total_tax
    end
    tax
  end

  def amt_payable
    total_cost + total_tax
  end
end
