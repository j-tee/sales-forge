class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscription_discount
  belongs_to :subscription_rate

  def stores
    user.stores.count
  end

  def subscriber
    user.username
  end

  def rate
    subscription_rate.rate
  end

  def frequency
    subscription_rate.frequency
  end

  def discount
    subscription_discount.discount 
  end
end
