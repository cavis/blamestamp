require 'test_helper'

class DeviseWorksTest < ActionController::TestCase
  setup do
    @controller = HomeController.new
  end

  test "logged out" do
    get :index
    assert_response :success
    assert_select "#loggedout"
  end

  test "login" do
    sign_in :user, users(:harold)
    get :index
    assert_response :success
    assert_select "#loggedin"
  end
end
