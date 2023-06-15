class StockSerializer
  include JSONAPI::Serializer
  attributes :id, :stock_date, :store_id, :details

  attribute :damages do |stock|
    stock.damages
  end

  attribute :expired do |stock|
    stock.expired
  end

  attribute :qty_of_product_sold do |stock|
    stock.qty_of_product_sold
  end

  attribute :total_cost do |stock|
    stock.total_cost
  end

  attribute :expected_revenue do |stock|
    stock.expected_revenue
  end

  attribute :actual_revenue do |stock|
    stock.actual_revenue
  end

  attribute :cost_of_damages do |stock|
    stock.cost_of_damages
  end

  attribute :cost_of_expired_products do |stock|
    stock.cost_of_expired_products
  end
end
