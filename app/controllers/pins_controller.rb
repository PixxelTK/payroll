class PinsController < ApplicationController
  def verify
    @employee = Employee.find(params.require(:employee_id))
    @redirect_to = params.require(:redirect_to)
  end

  def check
    employee = Employee.find(params.require(:employee_id))

    if employee.authenticate_pin(params.require(:pin))
      session[:pin_verified] = employee.id
      session[:pin_verified_at] = Time.current

      redirect_to params.require(:redirect_to)
    else
      flash.now[:alert] = "Invalid PIN please try again."
      @employee = employee
      @redirect_to = params[:redirect_to]
      render :verify, status: :unprocessable_entity
    end
  end
end
