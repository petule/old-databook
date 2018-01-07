require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get show_basket_url
    assert_response :success
  end

  test "should get payment" do
    get finish_basket_url
    assert_response :success
  end

  test "should get finish" do
    get finish_basket_url
    assert_response :success
  end

end
