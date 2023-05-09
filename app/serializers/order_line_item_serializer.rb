class OrderLineItemSerializer
  include JSONAPI::Serializer
  attributes :id, :quantity, :product_id, :order_id, :total_amount, :product_name

  attribute :total_amount do |order_line_item|
    order_line_item.calc_total_cost
  end

  attribute :product_name do |order_line_item|
    order_line_item.product.product_name
  end
  
  attribute :unit_price do |order_line_item|
    order_line_item.product.unit_price
  end

  attribute :total_discount do |order_line_item|
    order_line_item.calc_total_discount_value
  end

  attribute :total_tax do |order_line_item|
    order_line_item.calc_total_tax
  end

  attribute :amount_payable do |order_line_item|
    order_line_item.calc_amount_payable
  end
end
