class TaxSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :rate
end
