class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  include StoreHelpers
  include StockHelpers

  def def(_index)
    @subscriptions = Subscription.includes(:user, :subscription_discount, :subscription_rate)
                                .where(user_id: params[:id])
                                .order(created_at: :desc)
                                .all

    @subscriptions = @subscriptions.page(params[:page]).per(params[:per_page])
    render json: { subscriptions: SubscriptionSerializer.new(@subscriptions).serializable_hash,
                   pagination: {
                     total_items: @subscriptions.total_count,
                     per_page: @subscriptions.limit_value,
                     current_page: @subscriptions.current_page,
                     total_pages: @subscriptions.total_pages
                   } }
  end

  def rates
    @rates = SubscriptionRate.all
  end

end
