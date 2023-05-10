class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :update, :destroy]
  include StockHelpers

  def get_unique_product_per_stock
    @product_names = Product.where(stock_id: get_stock_id).distinct.order(product_name: :asc).pluck(:product_name)
    render json: @product_names
  end  

  def get_unique_unit_costs      
    @unit_costs = Product.where(stock_id: get_stock_id, category_id: params[:category_id]).distinct.pluck(:unit_cost)
  end

  def get_unique_product_names
    @product_names = Product.where(stock_id: get_stock_id, category_id: params[:category_id], country: params[:country]).distinct.pluck(:product_name)
    render json: @product_names
  end

  def get_unique_manafacturers
    @manufacturer = Product.where(stock_id: get_stock_id, category_id: params[:category_id], country: params[:country], product_name: params[:product_name]).distinct.pluck(:manufacturer)
    render json: @manufacturer
  end

  def get_unique_countries
    @countries = Product.where(stock_id: get_stock_id).distinct.pluck(:country);
    render json: @countries
  end
  
  def index
    p "===================product_name : #{params[:product_name]}=========================================="
    stock_id = get_stock_id
    if stock_id
      stock = Stock.find_by(id: stock_id)
      unless stock
        render json: { error: "Stock not found" }, status: :not_found
        return
      end
  
      @products = stock.products.includes(:category).joins(:category).select("products.*, categories.name AS category_name")
    end
  
      if params[:category_id].to_i > 0
        category = Category.find_by(id: params[:category_id])
        unless category
          render json: { error: "Category not found" }, status: :not_found
          return
        end
        @products = @products.where(category_id: params[:category_id])
      end
  
      if params[:country].present?
        @products = @products.where(country: params[:country])
      end
  
      if params[:manufacturer].present?
        @products = @products.where(manufacturer: params[:manufacturer])
      end
  
      if params[:product_name].present?
        @products = @products.where("LOWER(product_name) LIKE ?", "%#{params[:product_name].downcase}%")
      end
  
      if params[:expdate].present?
        @products = @products.where("exp_date <= ?", params[:expdate])
      end
    
  
    @total_items = @products.count
    @products = @products.page(params[:cur_page]).per(params[:items_per_page])
  
    render json: {
      products: ProductSerializer.new(@products).serializable_hash,
      pagination: { total_items: @total_items,
                   current_page: @products.current_page,
                   per_page: @products.limit_value }
    }
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end 
  
     
  def show
    id = params[:id].to_i
    @product = if id > 0
                 Product.find_by(id: id)
               else
                 Product.find_by(stock_id: get_stock_id)
               end
  
    if @product
      render json: @product.to_json
    else
      render json: { error: "Product not found" }, status: :not_found
    end
  end
  
  

    def create
      @product = Product.new(product_params)
      p @product
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

    private         

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:product_name, :unit_price, :unit_cost, :country, :manufacturer, :mnf_date, :exp_date, :qty_in_stock, :category_id, :stock_id, :picture)
    end
end
