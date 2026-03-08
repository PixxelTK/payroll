require "test_helper"

class AttendanceTest < ActiveSupport::TestCase
  setup do
    @employee = employees(:one)
  end

  test "valid attendance" do
    attendance = Attendance.new(
      employee: @employee,
      work_date: Date.tomorrow,
      check_in: Time.current,
      check_out: Time.current + 8.hours
    )

    assert attendance.valid?
  end

  test "work_date must be unique per employee" do
    existing = attendances(:one)

    attendance = Attendance.new(
      employee: existing.employee,
      work_date: existing.work_date,
      check_in: Time.current
    )

    assert_not attendance.valid?
    assert_includes attendance.errors[:work_date], "has already been taken"
  end

  test "check_out must be after check_in" do
    attendance = Attendance.new(
      employee: @employee,
      work_date: Date.today,
      check_in: Time.current,
      check_out: Time.current - 1.hour
    )

    assert_not attendance.valid?
    assert_includes attendance.errors[:check_out], "must be after check in"
  end

  test "work_hours calculation" do
    attendance = Attendance.new(
      employee: @employee,
      work_date: Date.today,
      check_in: Time.current,
      check_out: Time.current + 9.hours
    )

    assert_in_delta 9, attendance.work_hours, 0.01
  end

  test "ot_hours calculation" do
    attendance = Attendance.new(
      employee: @employee,
      work_date: Date.today,
      check_in: Time.current,
      check_out: Time.current + 10.hours
    )

    assert_in_delta 2, attendance.ot_hours, 0.01
  end

  test "no ot when work hours less than 8" do
    attendance = Attendance.new(
      employee: @employee,
      work_date: Date.today,
      check_in: Time.current,
      check_out: Time.current + 6.hours
    )

    assert_equal 0, attendance.ot_hours
  end
end
