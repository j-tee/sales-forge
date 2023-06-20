# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  include RackSessionFix
  include ActionController::Flash
  respond_to :html

  private

  def respond_with(resource, _opts = {})
    base_url = Rails.env.production? ? ENV['REACT_APP_BASE_URL'] : 'http://localhost:3001'

    if resource.persisted?
      redirect_to "#{base_url}/confirmation/?result=success", allow_other_host: true
    else
      redirect_to "#{base_url}/confirmation/?result=failure", allow_other_host: true
    end
  end

  # def respond_with(resource, _opts = {})
  #   if resource.persisted?
  #     render json: {
  #       status: { code: 200, message: 'Confirmed sucessfully.' },
  #       data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
  #     }
  #   else
  #     render json: {
  #       status: { code: 422, message: "User couldn't be confirmed successfully. #{resource.errors.full_messages.to_sentence}" }
  #     }, status: :unprocessable_entity
  #   end
  # end
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
