class Api::V1::CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]
  include StoreHelpers
  include StockHelpers
  def index    
    @customers = Customer.where(store_id: get_store_id)
    render json: @customers
  end

  def customer_list
    customers = Customer.joins(:orders).where(orders: { stock_id: get_stock_id }).distinct.order(:name)
    render json: customers
  end
  

  def customer_details
    storeId = get_store_id
    @customers = Customer.where(store_id: storeId)
    @customers = @customers.page(params[:page]).per(params[:per_page])
    render json: { customers: @customers,
                   pagination: {
                     total_items: @customers.total_count,
                     per_page: @customers.limit_value,
                     current_page: @customers.current_page,
                     total_pages: @customers.total_pages
                   } }
  end

  def reset
    @customer = Customer.new
  end

  def show
    @customer = set_customer
    render json: @customer
  end

  def create
    @customer = Customer.find_or_initialize_by(id: customer_params[:id])
    @customer.assign_attributes(customer_params)

    if @customer.save
      render json: @customer, status: :created
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      render json: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    set_customer
    @customer.destroy
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :address, :store_id, :created_at, :updated_at)
  end
end
