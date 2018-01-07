require 'test_helper'

class CustomersControllerTest < ActionDispatch::IntegrationTest

  setup do
    post customer_session_path, params: {customer: {email: 'user@email.com', password: 'heslo123'}}
    follow_redirect!
  end

  test "should get library" do
    get library_customers_url
    assert_response :success
  end

  test "should get history" do
    get history_customers_url
    assert_response :success
  end

  test "should get wishlist" do
    get wishlist_customers_url
    assert_response :success
  end

  test "should get edit" do
    get edit_customers_url
    assert_response :success
  end

  test "unlogged should not get library" do
    delete destroy_customer_session_path
    get library_customers_path
    assert_response :redirect
  end

  test "should get registration" do
    delete destroy_customer_session_path
    get new_customer_registration_url
    assert_response :success
  end

  test "should get sign in" do
    delete destroy_customer_session_path
    get new_customer_session_url
    assert_response :success
  end

  test "should get forgot password" do
    delete destroy_customer_session_path
    get new_customer_password_url
    assert_response :success
  end

end
