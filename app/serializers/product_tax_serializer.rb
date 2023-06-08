class ProductTaxSerializer
  include JSONAPI::Serializer
  attributes :id, :product_name, :checked
  attribute :checked do |product|
    false
  end
end
