class Api::V1::OrderLineItemsController < ApplicationController
  before_action :authenticate_user!
  include Kaminari::PageScopeMethods
  before_action :set_order_line_item, only: [:show, :update, :destroy]
  def index
    order = Order.find(params[:order_id])
  
    orders = Order.joins(:order_line_items, :customer).where(stock_id: order.stock_id)

    if params[:order_id].present?
      order_id = params[:order_id].to_i
      unless orders.pluck(:id).include?(order_id)
        render json: { error: "Invalid order ID" }, status: :bad_request
        return
      end
      orders = orders.where(id: order_id)
    end
  
    if params[:customer_id].present?
      customer_id = params[:customer_id].to_i
      orders = orders.where(customer_id: customer_id)
    end
  
    if params[:product_id].present?
      product_id = params[:product_id].to_i
      orders = orders.joins(:order_line_items).where(order_line_items: { product_id: product_id })
    end 
  
    order_line_items = OrderLineItem.where(order_id: orders.pluck(:id)).order(id: :desc)
    order_line_items = order_line_items.page(params[:page]).per(params[:per_page])
  
    render json: {
      order_line_items: OrderLineItemSerializer.new(order_line_items).serializable_hash,
      pagination: {
        total_items: order_line_items.total_count,
        per_page: order_line_items.limit_value,
        current_page: order_line_items.current_page,
        total_pages: order_line_items.total_pages
      }
    }
  end
      
  def show
    @order_line_item = OrderLineItem.find(params[:id])
    render json: @order_line_item
  end

  def create
    order_line_item_params = params.require(:order_line_item).permit(:quantity, :product_id, :order_id)
    @order_line_item = OrderLineItem.find_or_initialize_by(product_id: order_line_item_params[:product_id], order_id: order_line_item_params[:order_id])
    
    if @order_line_item.persisted?
      @order_line_item.quantity += 1
    else
      @order_line_item.quantity = order_line_item_params[:quantity]
    end
  
    if @order_line_item.save
      render json: @order_line_item, status: :created
    else
      render json: @order_line_item.errors, status: :unprocessable_entity
    end
  end  

  def update
    @order_line_item = OrderLineItem.find_by(id: params[:id])
  
    if @order_line_item
      if @order_line_item.update(order_line_item_params)
        render json: @order_line_item
      else
        render json: @order_line_item.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'OrderLineItem not found' }, status: :not_found
    end
  end
  

  def destroy
    @order_line_item.destroy
    head :no_content
  end

  private

  def set_order_line_item
    @order_line_item = OrderLineItem.find(params[:id])
  end

  def order_line_item_params
    params.require(:order_line_item).permit(:quantity, :product_id, :order_id, :id, :created_at, :updated_at)
  end
end
