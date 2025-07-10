class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 表示する年月を取得（パラメータがなければ今月）
    @year = params[:year]&.to_i || Date.current.year
    @month = params[:month]&.to_i || Date.current.month

    # その月の開始日・終了日
    @start_date = Date.new(@year, @month, 1)
    @end_date = @start_date.end_of_month

    # ログインユーザーの、その月の予約クラス情報を取得
    @reservations = current_user.reservations
                                .joins(:yoga_class)
                                .where(yoga_classes: { start_time: @start_date.beginning_of_day..@end_date.end_of_day })
                                .includes(:yoga_class)

    # カレンダー表示用: 日付ごとに予約したクラスをまとめる
    @reserved_dates = @reservations.map { |r| r.yoga_class.start_time.to_date }
  end

def day
  year = params[:year].to_i
  month = params[:month].to_i
  day = params[:day].to_i
  date = Date.new(year, month, day)

  # その日の予約クラス
  @reservations = current_user.reservations
                              .joins(:yoga_class)
                              .where(yoga_classes: { start_time: date.beginning_of_day..date.end_of_day })
                              .includes(:yoga_class)

  if @reservations.any?
    # 1つの場合は詳細画面へ直接遷移
    if @reservations.count == 1
      redirect_to yoga_class_path(@reservations.first.yoga_class)
    else
      # 複数ある場合は最初のクラスの詳細へ（または選択画面を作成）
      redirect_to yoga_class_path(@reservations.first.yoga_class)
    end
  else
    redirect_to calendar_path, alert: "この日に予約はありません。"
  end
end
end
