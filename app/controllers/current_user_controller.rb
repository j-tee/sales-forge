class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    render json: UserSerialzier.new(current_user).serializeable_hash[:data][:attributes], status: :ok
  end

  def show_by_email
    @user = User.where("email LIKE ?", "%#{params[:email]}%").first
    if @user
      render json: @user #UserSerialzier.new( @user).serializeable_hash[:data][:attributes], status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :password_digest, :store_id)
  end
end