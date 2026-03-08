require "test_helper"

class AttendancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:one)
    @attendance = attendances(:one)
  end

  test "should get checkin" do
    get checkin_attendances_url(employee_id: @employee.id)
    assert_response :success
  end

  test "should create attendance" do
    assert_difference("Attendance.count", 1) do
      post attendances_url, params: {
        attendance: {
          employee_id: @employee.id,
          work_date: Date.tomorrow,
          check_in: Time.current
        }
      }
    end

    assert_redirected_to employee_path(@employee)
  end

  test "should get checkout" do
    get checkout_attendance_url(@attendance)
    assert_response :success
  end
end
