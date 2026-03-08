class AttendancesController < ApplicationController
  def checkin
    @employee = Employee.find(params[:employee_id])
    @attendance = @employee.attendances.new(
      work_date: Date.today,
      check_in: Time.current
    )
  end

  def create
    @attendance = Attendance.new(attendance_params)

    if @attendance.save
      redirect_to employee_path(@attendance.employee), notice: "Checked in"
    else
      render :checkin, status: :unprocessable_entity
    end
  end

  def checkout
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])

    if @attendance.update(attendance_params)
      redirect_to employee_path(@attendance.employee), notice: "Attendance saved"
    else
      redirect_to employee_path(@attendance.employee), alert: "Attendance saved failed"
    end
  end

  private

  def attendance_params
    params.require(:attendance).permit(:employee_id, :work_date, :check_in, :check_out)
  end
end
