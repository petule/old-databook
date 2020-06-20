require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    skip "Dependency has changed and this test needs to be fixed"
    post user_session_path, params: {user: {email: 'user@email.com', password: 'heslo123'}}
    follow_redirect!
  end

  #todo: doplnit spravne cesty apod. az budou

  test "should get library" do
    skip "Dependency has changed and this test needs to be fixed"
    get library_customers_url
    assert_response :success
  end

  test "should get history" do
    skip "Dependency has changed and this test needs to be fixed"
    get history_customers_url
    assert_response :success
  end

  test "should get wishlist" do
    skip "Dependency has changed and this test needs to be fixed"
    get wishlist_customers_url
    assert_response :success
  end

  test "should get edit" do
    skip "Dependency has changed and this test needs to be fixed"
    get edit_customers_url
    assert_response :success
  end

  test "unlogged should not get library" do
    skip "Dependency has changed and this test needs to be fixed"
    delete destroy_customer_session_path
    get library_customers_path
    assert_response :redirect
  end

  test "should get registration" do
    skip "Dependency has changed and this test needs to be fixed"
    delete destroy_customer_session_path
    get new_customer_registration_url
    assert_response :success
  end

  test "should get sign in" do
    skip "Dependency has changed and this test needs to be fixed"
    get new_user_session_path
    assert_response :success
  end

  test "should get forgot password" do
    skip "Dependency has changed and this test needs to be fixed"
    delete destroy_customer_session_path
    get new_customer_password_url
    assert_response :success
  end

end
