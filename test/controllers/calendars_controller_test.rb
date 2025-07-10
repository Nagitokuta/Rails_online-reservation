require "test_helper"

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calendars_index_url
    assert_response :success
  end

  test "should get day" do
    get calendars_day_url
    assert_response :success
  end
end
