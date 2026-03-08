require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:one)
  end

  test "should get index" do
    get employees_url
    assert_response :success
  end

  test "should search employees by name" do
    Employee.create!(
      name: "Alice Developer",
      position: "Developer",
      salary: 1000,
      pin: "1234",
      pin_confirmation: "1234"
    )

    get employees_url, params: { q: "Alice" }

    assert_response :success
    assert_match "Alice Developer", @response.body
  end

  test "should return all employees when search empty" do
    get employees_url, params: { q: "" }

    assert_response :success
    assert_match @employee.name, @response.body
  end

  test "should get new" do
    get new_employee_url
    assert_response :success
  end

  test "should create employee" do
    assert_difference("Employee.count") do
      post employees_url, params: {
        employee: {
          name: "Test User",
          position: "Developer",
          salary: 1000,
          pin: "1234",
          pin_confirmation: "1234"
        }
      }
    end

    assert_redirected_to employees_url
  end

  test "should show employee (with pin verified)" do
    post check_pins_url, params: {
      employee_id: @employee.id,
      pin: "1234",
      redirect_to: employee_path(@employee)
    }

    get employee_url(@employee)
    assert_response :success
  end

  test "should redirect to verify pin if not verified" do
    get employee_url(@employee)

    assert_redirected_to verify_pins_path(
      employee_id: @employee.id,
      redirect_to: employee_path(@employee)
    )
  end

  test "should redirect if pin session expired" do
    post check_pins_url, params: {
      employee_id: @employee.id,
      pin: "1234",
      redirect_to: employee_path(@employee)
    }

    travel_to 6.minutes.from_now do
      get employee_url(@employee)

      assert_redirected_to verify_pins_path(
        employee_id: @employee.id,
        redirect_to: employee_path(@employee)
      )
    end
  end

  test "should get edit (with pin verified)" do
    post check_pins_url, params: {
      employee_id: @employee.id,
      pin: "1234",
      redirect_to: employee_path(@employee)
    }

    get edit_employee_url(@employee)
    assert_response :success
  end

  test "should update employee" do
    post check_pins_url, params: {
      employee_id: @employee.id,
      pin: "1234",
      redirect_to: employee_path(@employee)
    }

    patch employee_url(@employee), params: {
      employee: {
        name: "Updated Name",
        position: @employee.position,
        salary: @employee.salary
      }
    }

    assert_redirected_to employee_url(@employee)

    @employee.reload
    assert_equal "Updated Name", @employee.name
  end

  test "should destroy employee" do
    assert_difference("Employee.count", -1) do
      delete employee_url(@employee)
    end

    assert_redirected_to employees_url
  end
end
