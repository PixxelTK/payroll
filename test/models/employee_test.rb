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
end
