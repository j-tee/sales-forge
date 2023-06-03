class PaymentSerializer
  include JSONAPI::Serializer
  attributes :id, :amount, :total_qty, :total_cost, :payment_type, :order_id,
  :total_discount, :total_tax, :amount_payable, :balance

  belongs_to :order, class_name: 'OrderSerializer'

  attribute :balance do |payment|
    payment.calc_balance
  end
  attribute :amount_payable do |payment|
    payment.calc_amount_payable
  end
  
  attribute :total_tax do |payment|
    payment.calc_total_tax
  end

  attribute :total_discount do |payment|
    payment.calc_total_discount
  end

  attribute :total_cost do |payment|
    payment.calc_total_cost
  end
  
  attribute :total_qty do |payment|
    payment.calc_total_qty
  end
end
