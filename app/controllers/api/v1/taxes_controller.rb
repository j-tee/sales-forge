class Api::V1::TaxesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tax, only: %i[show update destroy]
  include StoreHelpers
  rescue_from StandardError, with: :handle_error
  def destroy_product_tax
    @product_tax = ProductTax.find_by(product_id: params[:product_id], tax_id: params[:tax_id])
    begin
      if @product_tax
        if @product_tax.destroyed?
          render json: { success: 'Product tax deleted successfully' }
        else
          render json: { error: 'Failed to delete product tax' }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Product tax not found' }, status: :not_found
      end
    rescue StandardError => e
      render json: { error: "An error occurred while deleting product tax: #{e.message}" },
             status: :internal_server_error
    end
  end

  def add_product_tax
    @product_tax = ProductTax.new(product_tax_params)
    if @product_tax.save
      render json: @product_tax
    else
      render json: @product_tax.errors, status: :unprocessable_entity
    end
  end

  def taxes_on_a_product
    product_id = params[:product_id].to_i

    taxes = Tax.joins(:products).where(product_taxes: { product_id: })
    render json: TaxSerializer.new(taxes).to_json
  end

  def taxed_products
    tax_id = params[:tax_id].to_i
    store_id = get_store_id

    product_taxes = ProductTax.joins(product: :taxes).preload(product: :taxes)
    product_taxes = product_taxes.where(taxes: { store_id: })

    product_taxes = product_taxes.where(tax_id:) if tax_id.positive?

    product_taxes = product_taxes.pluck('products.id AS product_id', 'products.product_name', 'taxes.name',
                                        'taxes.rate')
    product_taxes = product_taxes.map do |product_id, product_name, tax_name, rate|
      {
        product_id:,
        product_name:,
        name: tax_name,
        rate:
      }
    end
    product_taxes = Kaminari.paginate_array(product_taxes).page(params[:page]).per(params[:per_page])

    render json: {
      products: product_taxes,
      pagination: {
        total_items: product_taxes.total_count,
        per_page: product_taxes.limit_value,
        current_page: product_taxes.current_page,
        total_pages: product_taxes.total_pages
      }
    }
  end

  def index
    @taxes = Tax.includes(:store, :products).joins(:products).where(store_id: get_store_id)

    render json: @taxes
  end

  def without_taxes
    store_id = get_store_id
    tax_id = params[:tax_id].to_i
    @products_without_taxes = if tax_id.positive?
                                Product.left_outer_joins(:taxes)
                                       .joins(:stock)
                                       .where(stocks: { store_id: })
                                       .where('taxes.id IS NULL OR taxes.id != ?', tax_id)
                                       .distinct
                                       .order(product_name: :asc)
                                       .select(:id, :product_name)
                              else
                                Product.left_outer_joins(:taxes)
                                       .joins(:stock)
                                       .where(stocks: { store_id: }, taxes: { id: nil })
                                       .distinct
                                       .order(product_name: :asc)
                                       .select(:id, :product_name)
                              end

    @products_without_taxes = @products_without_taxes.page(params[:page]).per(params[:per_page])

    render json: {
      products: ProductTaxSerializer.new(@products_without_taxes).serializable_hash,
      pagination: {
        total_items: @products_without_taxes.total_count,
        current_page: @products_without_taxes.current_page,
        per_page: @products_without_taxes.limit_value,
        total_pages: @products_without_taxes.total_pages
      }
    }
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

  def product_tax_params
    params.require(:product_tax).permit(:product_id, :tax_id)
  end

  # Only allow a list of trusted parameters through.
  def tax_params
    params.require(:tax).permit(:name, :rate, :store_id)
  end

  def handle_error(exception)
    render json: { error: "An error occurred while processing your request: #{exception.message}" }, status: 500
  end
end
