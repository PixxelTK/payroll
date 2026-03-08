class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :set_employee, only: %i[ show edit update destroy confirm_destroy ]
  PIN_TIMEOUT = 5.minutes

  def index
    if session[:pin_verified] &&
      request.referer&.include?("/employees/#{session[:pin_verified]}")
      session.delete(:pin_verified)
      session.delete(:pin_verified_at)
    end

    if params[:q].present?
      @employees = Employee.where("name ILIKE ?", "%#{params[:q]}%")
    else
      @employees = Employee.all
    end
  end

  def show
    verified_employee = session[:pin_verified]
    verified_at = session[:pin_verified_at]

    valid_session =
      verified_employee == @employee.id &&
      verified_at.present? &&
      verified_at > PIN_TIMEOUT.ago

    unless valid_session
      session.delete(:pin_verified)
      session.delete(:pin_verified_at)

      redirect_to verify_pins_path(
        employee_id: @employee.id,
        redirect_to: employee_path(@employee)
      )
    end
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path, notice: "Employee was successfully created.", status: :see_other }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_path(@employee), notice: "Employee updated." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm_destroy
    @employee = Employee.find(params.expect(:id))
  end

  def destroy
    @employee.destroy!

    respond_to do |format|
      format.html { redirect_to employees_path, notice: "Employee was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_employee
      @employee = Employee.find(params.expect(:id))
    end

    def employee_params
      params.expect(employee: [ :name, :position, :salary, :pin, :pin_confirmation ])
    end
end
