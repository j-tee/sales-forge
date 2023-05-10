class Api::V1::CustomersController < ApplicationController
    before_action :set_customer, only: [:show, :edit, :update, :destroy]
include StoreHelpers
  
    def index
      @customers = Customer.where(store_id: get_store_id)
      render json: @customers
    end
  
    def reset
      @customer = Customer.new;
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
  