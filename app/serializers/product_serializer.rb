class ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :product_name, :unit_price, :unit_cost, :country, :manufacturer, :mnf_date, :exp_date, :qty_in_stock, :description, :supplier, :qty_sold, :total_expired, :qty_stolen, :qty_damaged, :category_id, :stock_id, :category_name

  attribute :formatted_mnf_date do |product|
    product.mnf_date&.strftime('%m/%d/%Y')
  end

  attribute :store_name do |product|
    product.stock.store.name
  end

  attribute :stock_details do |product|
    "#{product.stock_id} #{product.stock&.stock_date&.strftime('%m/%d/%Y')}"
  end

  attribute :formatted_exp_date do |product|
    product.exp_date&.strftime('%m/%d/%Y')
  end

  attribute :category_name do |product|
    product.category.name
  end

  attribute :qty_damaged do |product|
    product.qty_damaged
  end

  attribute :qty_of_product_sold do |product|
    product.qty_of_product_sold
  end

  attribute :qty_available do |product|
    product.qty_in_stock - product.qty_damaged - product.qty_of_product_sold
  end

  def serializable_hash
    hash = super
  end
end
