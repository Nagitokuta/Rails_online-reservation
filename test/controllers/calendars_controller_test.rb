# test/controllers/reservations_controller_test.rb
require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers  # 追加

  setup do
    @user = users(:one)        # fixture users.ymlの:oneを読み込み
    @reservation = reservations(:one) # fixture reservations.ymlの:one
    sign_in @user              # ログイン処理
  end

  test "should create reservation" do
    post reservations_path, params: {
      reservation: {
        user_id: @user.id,
        yoga_class_id: yoga_classes(:one).id
      }
    }
    assert_response :redirect
  end

  test "should destroy reservation" do
    delete reservation_path(@reservation)
    assert_response :redirect
  end
end
