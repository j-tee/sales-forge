class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show update destroy]
  include StoreHelpers
  include StockHelpers
  def index
    @orders = if params[:store_id]
                Order.where(store_id: params[:store_id],
                            customer_id: params[:customer_id],
                            status: params[:status])
              else
                Order.where(customer_id: params[:customer_id],
                            status: params[:status])
              end
    render json: @orders
  end

  def show
    @order = Order.find(id: params[:order_id])
    render json: @order
  end

  def order_details
    stock_id = get_stock_id
    emp_id = params[:employee_id].to_i
    cust_id = params[:customer_id].to_i
    status = params[:status]

    query = Order.where(stock_id:)
    query = query.where(employee_id: emp_id) if emp_id&.positive?
    query = query.where(customer_id: cust_id) if cust_id&.positive?
    query = query.where(status:) if status.present?

    @order_details = query.includes(:customer, :stock, :employee, :payments, :order_line_items)
    @order_details = @order_details.page(params[:page]).per(params[:per_page])
    render json: { order_details: OrderSerializer.new(@order_details).serializable_hash,
      pagination: {
        total_items: @order_details.total_count,
        per_page: @order_details.limit_value,
        current_page: @order_details.current_page,
        total_pages: @order_details.total_pages
      }}
  end

  def create
    @order = Order.new(order_params)
    @order.stock = Stock.find(params[:stock_id])
    @order.customer = Customer.find(params[:customer_id])
    @order.employee = Employee.find_by(email: current_user.email)

    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # def create
  #   @order = Order.new(order_params)
  #   @order.employee_id = Employee.find_by(email: current_user.email)
  #   if @order.save
  #     render json: @order, status: :created, location: api_order_url(@order)
  #   else
  #     render json: @order.errors, status: :unprocessable_entity
  #   end
  # end

  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :total, :stock_id, :customer_id, :employee_id)
  end
end
