class Api::V1::StocksController < ApplicationController
  before_action :set_stock, only: [:show, :update, :destroy]
  include StoreHelpers

  # GET /api/v1/stocks
  def index
    begin
      if params[:store_id].blank?
        raise ArgumentError, "store_id parameter is missing."
      else
        if params[:store_id].to_i <= 0
          @stocks = Stock.where(store_id: get_store_id)
        else
          @stocks = Stock.where(store_id: params[:store_id])
        end
      end
      render json: @stocks
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
    end
  end
  

  # GET /api/v1/stocks/:id
  def show
    @stock = Stock.find_by(id: params[:id])
    render json: @stock
  end

  # POST /api/v1/stocks
  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      render json: @stock, status: :created
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/stocks/:id
  def update
    if @stock.update(stock_params)
      render json: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/stocks/:id
  def destroy
    @stock.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stock
    @stock = Stock.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def stock_params
    params.require(:stock).permit(:stock_date, :store_id, :details)
  end
end
