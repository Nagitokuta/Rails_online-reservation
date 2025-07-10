# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    # 今後の予約（未来のクラス）
    @upcoming_reservations = @user.reservations
                                  .joins(:yoga_class)
                                  .where("yoga_classes.start_time >= ?", Time.current)
                                  .includes(:yoga_class)
                                  .order("yoga_classes.start_time ASC")

    # 過去の予約（終了したクラス）
    @past_reservations = @user.reservations
                              .joins(:yoga_class)
                              .where("yoga_classes.start_time < ?", Time.current)
                              .includes(:yoga_class)
                              .order("yoga_classes.start_time DESC")
  end

  def edit
    # ユーザー情報編集画面
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: "ユーザー情報を更新しました。"
    else
      render :edit, alert: "更新に失敗しました。"
    end
  end

  def edit_password
    # パスワード変更画面
  end

  def update_password
    if @user.update_with_password(password_params)
      bypass_sign_in(@user) # パスワード変更後そのままログイン状態維持
      redirect_to mypage_path, notice: "パスワードを変更しました。"
    else
      render :edit_password
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def feedbacks
  @feedbacks = current_user.feedbacks
                          .includes(:yoga_class)
                          .recent
                          .page(params[:page])
                          .per(10)
  end
end
