require "test_helper"

class PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:one)
  end

  test "should get verify" do
    get verify_pins_url, params: {
      employee_id: @employee.id,
      redirect_to: employee_path(@employee)
    }

    assert_response :success
  end

  test "should redirect when pin correct and set session" do
    post check_pins_url, params: {
      employee_id: @employee.id,
      pin: "1234",
      redirect_to: employee_path(@employee)
    }

    assert_redirected_to employee_path(@employee)

    assert_equal @employee.id, session[:pin_verified]
    assert session[:pin_verified_at].present?
  end

  test "should render verify when pin incorrect" do
    post check_pins_url, params: {
      employee_id: @employee.id,
      pin: "0000",
      redirect_to: employee_path(@employee)
    }

    assert_response :unprocessable_entity
    assert_select "h1", /Verify/i

    assert_nil session[:pin_verified]
    assert_nil session[:pin_verified_at]
  end
end
