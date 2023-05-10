class Api::V1::TaxesController < ApplicationController
  before_action :set_tax, only: %i[ show update destroy ]
  include StoreHelpers

  # GET /api/v1/taxes
  def index
    @taxes = Tax.includes(:store, :products).joins(:products).where(store_id: get_store_id)
  
    render json: @taxes
  end  

  def get_taxes
    @taxes = Tax
  .joins(:products)
  .joins(products: { order_line_items: :order })
  .where(orders: { id: params[:order_id] })
  .select('taxes.name, taxes.rate, products.product_name, products.unit_price, order_line_items.quantity, orders.id')
  .group('taxes.name, taxes.rate, products.product_name, products.unit_price, order_line_items.quantity, orders.id')

  @result = @taxes.group_by(&:name).map do |name, taxes|
    total_tax_amt = taxes.sum { |tax| (tax.rate / 100) * tax.unit_price * tax.quantity }
    total_price_before_tax = taxes.sum { |tax| tax.unit_price * tax.quantity }
    tax_pct = (total_tax_amt / total_price_before_tax) * 100
  
    {
      name: name,
      tax_amt: total_tax_amt,
      price_before_tax: total_price_before_tax,
      tax_pct: tax_pct
    }
  end
  # @result = @taxes.group_by { |tax| [tax.name, tax.product_name] }.map do |group, taxes|
  #   name, product_name = group
  #   total_tax_amt = taxes.sum { |tax| (tax.rate / 100) * tax.unit_price * tax.quantity }
  #   total_price_before_tax = taxes.sum { |tax| tax.unit_price * tax.quantity }
  #   tax_pct = (total_tax_amt / total_price_before_tax) * 100
  
  #   {
  #     name: name,
  #     product_name: product_name,
  #     tax_amt: total_tax_amt,
  #     price_before_tax: total_price_before_tax,
  #     tax_pct: tax_pct
  #   }
  # end 

    render json: @result
  end
  
  
  # GET /api/v1/taxes/1
  def show
    render json: @tax
  end

  # POST /api/v1/taxes
  def create
    @tax = Tax.new(tax_params)

    if @tax.save
      render json: @tax, status: :created, location: @tax
    else
      render json: @tax.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/taxes/1
  def update
    if @tax.update(tax_params)
      render json: @tax
    else
      render json: @tax.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/taxes/1
  def destroy
    @tax.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      @tax = Tax.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tax_params
      params.require(:tax).permit(:name, :rate)
    end
end
