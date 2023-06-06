class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :subscription_discount_id, :subscription_rate_id, :amount, :paid, :start_date, :end_date
  attribute :stores do |sub|
    sub.stores
  end

  attribute :subscriber do |sub|
    sub.subscriber
  end

  attribute :rate do |sub|
    sub.rate
  end

  attribute :frequency do |sub|
    sub.frequency
  end

  attribute :discount do |sub|
    sub.discount
  end
end
