class Api::V1::TaxesController < ApplicationController
  before_action :set_tax, only: %i[show update destroy]
  include StoreHelpers

  # GET /api/v1/taxes

  def taxed_products
    tax_id = params[:tax_id].to_i
    store_id = get_store_id

    @product_taxes = ProductTax.includes(product: :taxes).where(taxes: { store_id: })
    
    if tax_id > 0
      @product_taxes = @product_taxes.where(tax_id:)
    end

    @product_taxes = @product_taxes.select('products.id AS product_id', 'products.product_name', 'taxes.name AS tax_name',
                                           'taxes.rate')
    render json: @product_taxes
  end

  def index
    @taxes = Tax.includes(:store, :products).joins(:products).where(store_id: get_store_id)

    render json: @taxes
  end

  def apply_tax_to_specific_products
    products = params[:products]
    tax_id = params[:tax_id]

    products.each do |product|
      product_tax = ProductTax.new(product_id: product[:id], tax_id:)

      if product_tax.save
        puts 'Database updated successfully'
      else
        # Handle the error, e.g., log the error message or take appropriate action
        puts "Error saving ProductTax for product #{product[:id]}: #{product_tax.errors.full_messages}"
      end
    end
  end

  def apply_tax
    tax_id = params[:tax_id]

    products_with_taxes = Product.includes(:taxes)
                                 .where.not(taxes: { id: tax_id })
                                 .distinct
                                 .order(product_name: :asc)
                                 .select(:id, :product_name)

    products_without_taxes = Product.left_outer_joins(:taxes)
                                    .where(taxes: { id: nil })
                                    .distinct
                                    .order(product_name: :asc)
                                    .select(:id, :product_name)

    @products = products_with_taxes + products_without_taxes

    @products.each do |product|
      if product.taxes.exists?(id: tax_id)
        puts "Product #{product.id} already has tax #{tax_id} applied"
      else
        product.taxes << Tax.find(tax_id)
        puts "Tax #{tax_id} applied to product #{product.id}"
      end
    end
    product_taxes = ProductTax.includes(product: :taxes)
                              .where(tax_id:)
                              .joins(product: :taxes)
                              .select('products.id AS product_id', 'products.product_name', 'taxes.name', 'taxes.rate')

    render json: product_taxes
  end

  def tax_list
    @taxes = Tax.where(store_id: get_store_id)
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
        name:,
        tax_amt: total_tax_amt,
        price_before_tax: total_price_before_tax,
        tax_pct:
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
    @tax.store = Store.find(@tax.store_id)
    if @tax.save
      render json: @tax, status: :created
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
    params.require(:tax).permit(:name, :rate, :store_id)
  end
end
