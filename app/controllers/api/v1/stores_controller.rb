class Api::V1::StoresController < ApplicationController
    before_action :authenticate_user!
    before_action :set_store, only: [:show, :update, :destroy]
    
    def index
      if (current_user.has_role?(:system_admin) || current_user.has_role?(:staff)) && params[:user_id]
        @stores = Store.where(user_id: params[:user_id])
      elsif current_user.has_role?(:system_admin) && !params[:user_id]
        @stores = Store.all
      elsif current_user.has_role?(:admin)
        @stores = Store.where(user_id: current_user.id)
      else
        render json: { error: "You are not authorized to perform this action" }, status: :unauthorized
        return
      end
      render json: @stores
    end
           
  
    def show
      render json: @store
    end
  
    def create
      @store = current_user.stores.build(store_params)
      @store.user_id = current_user.id
  
      if @store.save
        render json: @store, status: :created
      else
        render json: @store.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @store.update(store_params)
        render json: @store
      else
        render json: @store.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @store.destroy
      head :no_content
    end
  
    private
  
    def set_store
      @store = Store.find(params[:id])
    end
  
    def store_params
      params.require(:store).permit(:name, :address)
    end
  end
  