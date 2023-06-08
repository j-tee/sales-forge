class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :subscription_discount_id, :subscription_rate_id, :amount, :paid, :start_date, :end_date
  attribute :num_stores do |sub|
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

  attribute :discount_amount do |sub|
    sub.subscription_amount * sub.discount
  end

  attribute :subscription_amount do |sub|
    sub.rate * sub.stores
  end

  attribute :tax do |sub|
    sub.tax
  end

  attribute :tax_amount do |sub|
    sub.subscription_amount * sub.tax
  end

  attribute :amt_due do |sub|
    (sub.subscription_amount + sub.subscription_amount * sub.tax) - sub.subscription_amount * sub.discount
  end
end
