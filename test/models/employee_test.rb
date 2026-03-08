require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  def valid_employee
    Employee.new(
      name: "John",
      position: "Developer",
      salary: 50000,
      pin: "1234",
      pin_confirmation: "1234"
    )
  end

  test "valid employee" do
    assert valid_employee.valid?
  end

  test "name must be present" do
    employee = valid_employee
    employee.name = nil
    assert_not employee.valid?
  end

  test "position must be present" do
    employee = valid_employee
    employee.position = nil
    assert_not employee.valid?
  end

  test "position must be in allowed list" do
    employee = valid_employee
    employee.position = "CEO"
    assert_not employee.valid?
  end

  test "salary must be >= 0" do
    employee = valid_employee
    employee.salary = -1
    assert_not employee.valid?
  end

  test "salary can be nil" do
    employee = valid_employee
    employee.salary = nil
    assert employee.valid?
  end

  test "pin must be 4 digits" do
    employee = valid_employee
    employee.pin = "12"
    employee.pin_confirmation = "12"
    assert_not employee.valid?
  end

  test "pin must contain only digits" do
    employee = valid_employee
    employee.pin = "abcd"
    employee.pin_confirmation = "abcd"
    assert_not employee.valid?
  end

  test "can update without changing pin" do
    employee = valid_employee
    employee.save!

    employee.update(name: "Updated Name")

    assert employee.valid?
  end

  test "monthly_working_days counts only checked out attendances" do
    employee = valid_employee
    employee.save!

    date = Date.new(2030, 1, 1)

    employee.attendances.create!(
      work_date: date,
      check_in: Time.current,
      check_out: Time.current + 8.hours
    )

    employee.attendances.create!(
      work_date: date + 1.day,
      check_in: Time.current
    )

    assert_equal 1, employee.monthly_working_days(date)
  end

  test "monthly_ot_hours sums ot hours in month" do
    employee = valid_employee
    employee.save!

    date = Date.new(2030, 1, 1)

    employee.attendances.create!(
      work_date: date,
      check_in: Time.current,
      check_out: Time.current + 10.hours
    )

    employee.attendances.create!(
      work_date: date + 1.day,
      check_in: Time.current,
      check_out: Time.current + 9.hours
    )

    assert_in_delta 3, employee.monthly_ot_hours(date), 0.01
  end

  test "monthly_ot_pay calculation" do
    employee = valid_employee
    employee.save!

    date = Date.new(2030, 1, 1)

    employee.attendances.create!(
      work_date: date,
      check_in: Time.current,
      check_out: Time.current + 10.hours
    )

    ot_hours = employee.monthly_ot_hours(date)
    expected = ot_hours * (employee.salary / 30.0 / 8)

    assert_in_delta expected, employee.monthly_ot_pay(date), 0.01
  end

  test "monthly_tax calculation with bracket" do
    employee = valid_employee
    employee.save!

    date = Date.new(2030, 1, 1)

    tax = employee.monthly_tax(date)

    expected = (20000 * 0.05) + ((employee.salary - 50000) * 0.10)

    assert_in_delta expected, tax, 0.01
  end

  test "monthly_net_pay returns 0 if no attendance" do
    employee = valid_employee
    employee.save!

    date = Date.new(2030, 1, 1)

    assert_equal 0, employee.monthly_net_pay(date)
  end

  test "monthly_net_pay calculation" do
    employee = valid_employee
    employee.save!

    date = Date.new(2030, 1, 1)

    employee.attendances.create!(
      work_date: date,
      check_in: Time.current,
      check_out: Time.current + 10.hours
    )

    net = employee.salary + employee.monthly_ot_pay(date) - employee.monthly_tax(date)

    assert_in_delta net, employee.monthly_net_pay(date), 0.01
  end
end
