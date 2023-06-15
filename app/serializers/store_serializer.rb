class StoreSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :address, :email, :phone1, :phone2, :user_id

  attribute :cost_of_expired_products do |store|
    store.cost_of_expired_products
  end

  attribute :total_cost do |store|
    store.total_cost
  end

  attribute :cost_of_damages do |store|
    store.cost_of_damages
  end

  attribute :expected_revenue do |store|
    store.expected_revenue
  end

  attribute :actual_revenue do |store|
    store.actual_revenue
  end

  attribute :damages do |store|
    store.damages
  end

  attribute :expired do |store|
    store.expired
  end
end
