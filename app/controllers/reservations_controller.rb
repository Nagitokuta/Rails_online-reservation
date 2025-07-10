class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @yoga_class = YogaClass.find(params[:yoga_class_id])

    # 既に予約済みかチェック
    if current_user.reserved_yoga_class?(@yoga_class)
      redirect_to root_path, alert: "既にこのクラスを予約済みです。"
      return
    end

    # 満席かチェック
    if @yoga_class.full?
      redirect_to root_path, alert: "このクラスは満席です。"
      return
    end

    # 予約作成
    @reservation = current_user.reservations.build(yoga_class: @yoga_class)

    if @reservation.save
      redirect_to root_path, notice: "#{@yoga_class.name}の予約が完了しました！"
    else
      redirect_to root_path, alert: "予約に失敗しました。#{@reservation.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    @yoga_class = @reservation.yoga_class

    # 開始時刻の1時間前以降はキャンセル不可
    if @yoga_class.start_time <= 1.hour.from_now
      redirect_to mypage_path, alert: "開始1時間前以降はキャンセルできません。"
      return
    end

    @reservation.destroy
    redirect_to mypage_path, notice: "#{@yoga_class.name}の予約をキャンセルしました。"
  end
end
