class CategorySerializer
  include JSONAPI::Serializer
  attributes :id, :name
  has_many :products
end
