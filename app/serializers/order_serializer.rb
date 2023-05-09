class OrderSerializer
  include JSONAPI::Serializer
  attributes :id, :status, :total, :customer_id, :employee_id, :stock_id
end
