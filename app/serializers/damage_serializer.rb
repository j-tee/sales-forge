class DamageSerializer
  include JSONAPI::Serializer
  attribute :product_id, :category, :quantity, :damage_date

  attributes :product_name do |damage|
    damage.product_name
  end
end