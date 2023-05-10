class Api::V1::PaymentsController < ApplicationController
    def index
        @payments = []
        if params[:id].to_i > 0 
          @payments = Payment.find_by(id: params[:id])
        elsif params[:order_id].to_i > 0
          @payments = Payment.where(order_id: params[:order_id])
        elsif params[:store_id].to_i > 0
          @payments = Order.where(store_id: params[:store_id]).pluck(:payments)
        end
      
        if @payments.present?
          render json: { payments: PaymentSerializer.new(@payments).serializable_hash }, status: :ok
        else
          render json: { error: "No payments found." }, status: :not_found
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end      
  
    def show
      @payment = Payment.find(params[:id])
      render json: { payment: PaymentSerializer.new(@payment).serializable_hash }
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Payment not found' }, status: :not_found
    end
  
    def create
      @payment = Payment.new(payment_params)
      payment = Payment.find_by(order_id: @payment.order_id)
      if payment.nil?
        if @payment.save
          render json: { payment: PaymentSerializer.new(@payment).serializable_hash }, status: :created
        else
          render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Payment already effected' }, status: :bad_request
      end
    end
  
    def update
      @payment = Payment.find(params[:id])
      if @payment.update(payment_params)
        render json: { payment: PaymentSerializer.new(@payment).serializable_hash }, status: :ok
      else
        render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Payment not found' }, status: :not_found
    end
  
    def destroy
      @payment = Payment.find(params[:id])
      @payment.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Payment not found' }, status: :not_found
    end
  
    private
  
    def payment_params
      params.require(:payment).permit(:amount, :payment_type, :order_id)
    end
  end
  