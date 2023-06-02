class OrderSerializer
  include JSONAPI::Serializer
  attributes :id, :status, :total, :customer_id, :employee_id, :stock_id
  attribute :total_cost, &:total_cost
  attribute :customer_name, &:customer_name
  attribute :employee_name, &:employee_name

  attribute :total_tax do |order|
    order.total_tax
  end

  attribute :amt_payable do |order|
    order.amt_payable
  end

  attribute :total_payment do |order|
    order.get_total_payment
  end
end
