class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]

  def index
    @employees = Employee.all
  end

  def show
    unless session[:pin_verified] == @employee.id
      redirect_to verify_pins_path(
        employee_id: @employee.id,
        redirect_to: employee_path(@employee)
      )
      return
    end

    session.delete(:pin_verified)
  end

  def new
    @employee = Employee.new
  end

  def edit
    unless session[:pin_verified] == @employee.id
      redirect_to verify_pins_path(
        employee_id: @employee.id,
        redirect_to: edit_employee_path(@employee)
      )
      return
    end

    session.delete(:pin_verified)
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
        format.html { redirect_to employees_path, notice: "Employee was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
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
