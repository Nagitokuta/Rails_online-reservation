# test/controllers/reservations_controller_test.rb
require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should create reservation" do
    post reservations_path, params: {
      reservation: {
        user_id: users(:one).id,
        yoga_class_id: yoga_classes(:one).id
      }
    }
    assert_response :redirect
  end

  test "should destroy reservation" do
    reservation = reservations(:one) # fixtureで用意しているもの
    delete reservation_path(reservation)
    assert_response :redirect
  end
end