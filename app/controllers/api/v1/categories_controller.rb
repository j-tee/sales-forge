class Api::V1::CategoriesController < ApplicationController
  include StoreHelpers
    before_action :set_category, only: [:show, :update, :destroy]
    

  def index
    storeId = get_store_id
    @categories = Category.where(store_id: storeId)
    render json: @categories
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :store_id)
  end
end
