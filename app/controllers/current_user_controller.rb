class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    render json: UserSerialzier.new(current_user).serializeable_hash[:data][:attributes], status: :ok
  end

  def show_by_email
    @user = User.where('email LIKE ?', "%#{params[:email]}%").first
    return unless @user

    render json: @user # UserSerialzier.new( @user).serializeable_hash[:data][:attributes], status: :ok
    # else
    #   render json: { error: 'User not found' }, status: :not_found
  end

  def get_roles
    @roles = Role.all
    unless current_user.has_role?('system_admin')
      @roles = @roles.reject { |role| %w[system_admin staff].include?(role.name) }
    end

    render json: @roles
  end

  def create_role(role_name)
    Role.create(name: role_name)
  end

  # PUT /resource/add_role
  def add_role
    current_user.add_role(params[:role])
    render json: { message: "Role '#{params[:role]}' added to user" }, status: :ok
  end

  def add_user_to_role
    @users_roles = UsersRole.find_by(users_roles_params)
  
    if @users_roles.nil?
      @users_roles = UsersRole.new(users_roles_params)
      if @users_roles.save
        render json: @users_roles
      else
        render json: @users_roles.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'Record already exists' }, status: :unprocessable_entity
    end
  end
  

  # DELETE /resource/remove_role
  def remove_role
    user_role = UsersRole.where(user_id: params[:user_id], role_id: params[:role_id]).first
    if user_role
      user_role.destroy
      render json: { message: "Role '#{user_role.role.name}' removed from user" }, status: :ok
    else
      render json: { error: 'Role not found or unauthorized' }, status: :not_found
    end
  end
  
  

  def users_roles_params
    params.require(:users_roles).permit(:user_id, :role_id)
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :password_digest, :store_id)
  end
end
