class Api::V1::OrdersController < ApplicationController
    before_action :set_order, only: [:show, :update, :destroy]
  
    def index
       if params[:store_id]
        @orders = Order.where(store_id: params[:store_id], 
               customer_id: params[:customer_id], 
               status: params[:status])
       else
        @orders = Order.where(customer_id: params[:customer_id], 
               status: params[:status])
       end
        render json: @orders
      end      
  
    def show
        @order = Order.find(id: params[:order_id])
      render json: @order
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
  