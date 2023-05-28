class Order < ApplicationRecord
  belongs_to :stock
  belongs_to :customer
  belongs_to :employee
  has_many :order_line_items
  has_many :products, through: :order_line_items
  has_many :payments

  def get_total_payment
    total_payment = 0
    self.payments.each do |payment|
      total_payment += payment.amount
    end
    total_payment
  end
end
