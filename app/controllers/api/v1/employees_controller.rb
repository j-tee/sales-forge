class Api::V1::EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show update destroy]
  include StoreHelpers
  # GET /employees
  def index
    store_id = get_store_id
    @employees = Employee.includes(:store).where(store_id:)
    render json: { employees: EmployeeSerializer.new(@employees).serializable_hash }, status: :ok
  end

  # GET /employees/1
  def show
    @employee = Employee.find_by(id: params[:id])
    if @employee
      render json: { employee: EmployeeSerializer.new(@employee).serializable_hash }, status: :ok
    else
      render json: { error: 'Employee not found' }, status: :not_found
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee, status: :created, location: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      render json: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employees/1
  def destroy
    @employee.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def employee_params
    params.require(:employee).permit(:name, :email, :password_digest, :store_id)
  end
end
