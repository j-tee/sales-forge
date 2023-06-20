class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show update destroy]
  include StockHelpers
  include StoreHelpers

  def product_without_specific_tax
    @products = Product.joins(:product_taxes)
                       .where.not(product_taxes: { tax_id: params[:tax_id] })
                       .distinct
                       .order(product_name: :asc)
                       .select(:id, :product_name)
    render json: @products
  end

  def unique_product_names_by_category
    @product_names = Product.where(category_id: params[:category_id]).distinct.order(product_name: :asc).pluck(:product_name)
    render json: @product_names
  end

  def get_unique_product_per_stock
    @product_names = Product.where(stock_id: get_stock_id).distinct.order(product_name: :asc).pluck(:product_name)
    render json: @product_names
  end

  def get_unique_unit_costs
    @unit_costs = Product.where(stock_id: get_stock_id, category_id: params[:category_id]).distinct.pluck(:unit_cost)
  end

  def get_unique_product_names
    @product_names = Product.where(stock_id: get_stock_id, category_id: params[:category_id],
                                   country: params[:country]).distinct.pluck(:product_name)
    render json: @product_names
  end

  def get_unique_manafacturers
    @manufacturer = Product.where(stock_id: get_stock_id, category_id: params[:category_id], country: params[:country],
                                  product_name: params[:product_name]).distinct.pluck(:manufacturer)
    render json: @manufacturer
  end

  def get_unique_countries
    @countries = Product.where(stock_id: get_stock_id).distinct.pluck(:country)
    render json: @countries
  end

  def index
    stock_id = get_stock_id
    if stock_id
      stock = Stock.find_by(id: stock_id)
      unless stock
        render json: { error: 'Stock not found' }, status: :not_found
        return
      end

      @products = stock.products.includes(:category).joins(:category).select('products.*, categories.name AS category_name')
    end

    if params[:category_id].to_i > 0
      category = Category.find_by(id: params[:category_id])
      unless category
        render json: { error: 'Category not found' }, status: :not_found
        return
      end
      @products = @products.where(category_id: params[:category_id])
    end

    @products = @products.where(country: params[:country]) if params[:country].present?

    @products = @products.where(manufacturer: params[:manufacturer]) if params[:manufacturer].present?

    if params[:product_name].present?
      @products = @products.where('LOWER(product_name) LIKE ?', "%#{params[:product_name].downcase}%")
    end

    @products = @products.where('exp_date <= ?', params[:expdate]) if params[:expdate].present?

    @total_items = @products.count
    @products = @products.page(params[:cur_page]).per(params[:items_per_page])

  
    curr_sales = Payment.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day)
                        .where(order_id: Order.where(stock_id: Stock.where(store_id: get_store_id)).pluck(:id))
                        .sum(:amount)

    render json: {
      products: ProductSerializer.new(@products).serializable_hash,
      pagination: { total_items: @total_items,
                    current_page: @products.current_page,
                    per_page: @products.limit_value },
      sales: curr_sales
    }
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    id = params[:id].to_i
    @product = if id > 0
                 Product.find_by(id:)
               else
                 Product.find_by(stock_id: get_stock_id)
               end

    if @product
      render json: @product.to_json
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def notifications
    store_id = get_store_id
    begin
      @notifications = Notification.where(store_id:)
      render json: @notifications
    rescue StandardError => e
      render json: { error: "An error occurred while fetching notifications: #{e.message}" },
             status: :unprocessable_entity
    end
  end

  def add_notification
    @notification = Notification.new(notification_params)
    if @notification.save
      render json: @notification, status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  def damages
    store_id = get_store_id
    product_id = params[:product_id].to_i

    store = Store.find_by(id: store_id)
    return render json: { error: 'Store not found' }, status: :not_found unless store

    @damages = if product_id.positive?
                 Damage.joins(product: { stock: :store }).where('stores.id = ? AND products.id = ?', store_id,
                                                                product_id)
               else
                 Damage.joins(product: { stock: :store }).where('stores.id = ?', store_id)
               end

    @total_items = @damages.count
    @damages = @damages.page(params[:page]).per(params[:per_page])

    render json: {
      damages: DamageSerializer.new(@damages).serializable_hash,
      pagination: { total_items: @total_items,
                    page: @damages.current_page,
                    per_page: @damages.limit_value }
    }
  end

  def add_damages
    @damage = Damage.new(damage_params)
    if @damage.save
      render json: @damage
    else
      render json: @damage.errors, status: :unprocessable_entity
    end
  end

  def update_damages
    set_damages
    if @damage.update(damage_params)
      render json: @damage
    else
      render json: @damage.errors, status: :unprocessable_entity
    end
  end

  private

  def set_damages
    @damage = Damage.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:store_id, :notification_type, :value)
  end

  def damage_params
    params.require(:damages).permit(:id, :category, :product_id, :quantity, :damage_date)
  end

  def product_params
    params.require(:product).permit(:id, :product_name, :unit_price, :unit_cost, :description, :country, :manufacturer, :mnf_date,
                                    :exp_date, :qty_in_stock, :category_id, :stock_id, :picture)
  end
end
