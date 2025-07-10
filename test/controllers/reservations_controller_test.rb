# test/controllers/calendars_controller_test.rb
require "test_helper"

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers  # 追加

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get calendar_path
    assert_response :success
  end

  test "should get day" do
    get calendar_day_path
    assert_response :success
  end
end
