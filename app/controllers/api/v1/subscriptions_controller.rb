class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  include StoreHelpers
  include StockHelpers

  def index
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

  def consolidated_taxes
    @tax = SubscriptionTax.select('DISTINCT ON (name) name, rate, created_at')
                          .order('name, created_at DESC')
                          .sum(:rate)

    render json: @tax
  end

  def rates
    @rates = SubscriptionRate.all
    render json: @rates
  end

  def create
    stores_count = Store.where(user_id: current_user.id).count
    
    # Find the appropriate discount_id using a single query
    discount_id = SubscriptionDiscount.where('stores <= ?', stores_count).order(stores: :desc).limit(1).pluck(:id).first

    # Handle the case when no discount is found
    discount_id ||= SubscriptionDiscount.order(stores: :desc).limit(1).pluck(:id).first

    @subscription = Subscription.new(subscription_params)
    @subscription.user_id = current_user.id
    @subscription.subscription_discount_id = discount_id

    if @subscription.save
      render json: { message: 'Subscription created successfully' }, status: :created
    else
      render json: { error: 'Failed to create subscription' }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:amount, :paid, :start_date, :end_date, :user_id, :subscription_discount_id,
                                         :subscription_rate_id)
  end
end
