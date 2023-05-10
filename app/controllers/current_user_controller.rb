class CurrentUserController < ApplicationController
  # before_action :authenticate_user!
  def index
    render json: UserSerialzier.new(current_user).serializeable_hash[:data][:attributes], status: :ok
  end

  def show_by_email
    username = params[:email].split("@")[0]
    @user = User.where("email LIKE ?", "%#{username}%").first
    p "@user===============================#{@user.email}"
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