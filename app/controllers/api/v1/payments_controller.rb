class Api::V1::PaymentsController < ApplicationController
  include StoreHelpers
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
      render json: { error: 'No payments found.' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def payment_details
    customer_id = params[:customer_id].to_i
    employee_id = params[:employee_id].to_i
    start_date = params[:startDate]&.to_date
    end_date = params[:endDate]&.to_date

    @payments = if customer_id > 0 && employee_id > 0 && start_date && end_date
                  Order.where(store_id: params[:store_id], order_id: params[:order_id], customer_id:,
                              employee_id:, created_at: start_date..end_date).pluck(:id)
                elsif customer_id > 0 && employee_id > 0
                  Order.where(store_id: params[:store_id], order_id: params[:order_id], customer_id:,
                              employee_id:).pluck(:id)
                elsif customer_id > 0 && start_date && end_date
                  Order.where(store_id: params[:store_id], order_id: params[:order_id], customer_id:,
                              created_at: start_date..end_date).pluck(:id)
                elsif employee_id > 0 && start_date && end_date
                  Order.where(store_id: params[:store_id], order_id: params[:order_id], employee_id:,
                              created_at: start_date..end_date).pluck(:id)
                elsif customer_id > 0
                  Order.where(store_id: params[:store_id], order_id: params[:order_id],
                              customer_id:).pluck(:id)
                elsif employee_id > 0
                  Order.where(store_id: params[:store_id], order_id: params[:order_id],
                              employee_id:).pluck(:id)
                elsif start_date && end_date
                  Order.where(store_id: params[:store_id], order_id: params[:order_id],
                              created_at: start_date..end_date).pluck(:id)
                elsif params[:order_id].to_i > 0 && params[:store_id].to_i > 0
                  Order.where(store_id: params[:store_id], order_id: params[:order_id]).pluck(:id)
                elsif params[:order_id].to_i > 0
                  Payment.where(order_id: params[:order_id]).pluck(:id)
                elsif params[:store_id].to_i > 0
                  Order.where(store_id: params[:store_id]).pluck(:id)
                elsif params[:store_id].to_i > 0 && start_date && end_date
                  Order.where(store_id: params[:store_id], created_at: start_date..end_date).pluck(:id)
                else
                  []
                end

    @payments = Payment.where(order_id: @payments)
                       .order(id: :desc)
                       .page(params[:page])
                       .per(params[:per_page])

    if @payments.present?
      render json: {
        payments: PaymentSerializer.new(@payments).serializable_hash,
        pagination: {
          total_items: @payments.total_count,
          per_page: @payments.limit_value,
          current_page: @payments.current_page,
          total_pages: @payments.total_pages
        }
      }, status: :ok
    else
      render json: { error: 'No payments found.' }, status: :not_found
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
        order = Order.find(@payment.order_id)
        order.status = 'Complete'
        order.save # Save the updated order status
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
