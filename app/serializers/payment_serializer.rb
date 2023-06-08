class PaymentSerializer
  include JSONAPI::Serializer
  attributes :id, :amount, :payment_type, :order_id

  attribute :order_date do |payment|
    payment.order.created_at
  end

  attribute :customer_id do |payment|
    payment.order.customer.id
  end

  attribute :customer_name do |payment|
    payment.order.customer.name
  end

  attribute :amt_due do |payment|
    amt = 0
    payment.order.order_line_items.each do |item|
      amt += item.calc_amount_payable
    end
    amt
  end
  
  attribute :payment_date do |payment|
    payment.created_at.strftime("%Y-%m-%d")
  end

  attribute :employee do |payment|
    payment.order.employee.name
  end
  # :total_discount, :total_tax, :amount_payable, :balance

  # belongs_to :order, class_name: 'OrderSerializer'

  # attribute :balance do |payment|
  #   payment.calc_balance
  # end
  # attribute :amount_payable do |payment|
  #   payment.calc_amount_payable
  # end
  
  # attribute :total_tax do |payment|
  #   payment.calc_total_tax
  # end

  # attribute :total_discount do |payment|
  #   payment.calc_total_discount
  # end

  # attribute :total_cost do |payment|
  #   payment.calc_total_cost
  # end
  
  # attribute :total_qty do |payment|
  #   payment.calc_total_qty
  # end
end
