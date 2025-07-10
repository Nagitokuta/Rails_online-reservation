# app/controllers/yoga_classes_controller.rb
class YogaClassesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_yoga_class, only: [ :show, :live, :join_live, :leave_live ]

  def index
    @yoga_classes = YogaClass.where("start_time >= ?", Time.current)
                             .order(:start_time)
  end

  def show
    @user_reservation = current_user.reservations.find_by(yoga_class: @yoga_class)
    @is_reserved = @user_reservation.present?
    @can_reserve = @yoga_class.available? && !@is_reserved
  end

  def live
    # 予約していないユーザーはアクセス不可
    unless @yoga_class.live_available_for_user?(current_user)
      redirect_to @yoga_class, alert: "このライブ配信にアクセスする権限がありません。"
      return
    end

    # ライブ配信が開始されていない場合
    unless @yoga_class.can_join_live?
      redirect_to @yoga_class, alert: "ライブ配信はまだ開始されていません。"
      return
    end

    # 参加記録を作成または更新
    @participation = current_user.live_participations
                                 .find_or_initialize_by(yoga_class: @yoga_class)

    if @participation.new_record? || !@participation.active?
      @participation.update!(
        joined_at: Time.current,
        left_at: nil
      )
    end

    @user_reservation = current_user.reservations.find_by(yoga_class: @yoga_class)
    @current_participants = @yoga_class.current_participants_count
  end

  def join_live
    unless @yoga_class.live_available_for_user?(current_user)
      render json: { error: "アクセス権限がありません" }, status: :forbidden
      return
    end

    participation = current_user.live_participations
                                .find_or_initialize_by(yoga_class: @yoga_class)

    participation.update!(
      joined_at: Time.current,
      left_at: nil
    )

    render json: {
      success: true,
      participants_count: @yoga_class.current_participants_count
    }
  end

  def leave_live
    participation = current_user.live_participations
                                .find_by(yoga_class: @yoga_class)

    if participation&.active?
      duration = ((Time.current - participation.joined_at) / 1.minute).round
      participation.update!(
        left_at: Time.current,
        duration_seconds: duration * 60
      )
    end

    render json: {
      success: true,
      participants_count: @yoga_class.current_participants_count
    }
  end

  private

  def set_yoga_class
    @yoga_class = YogaClass.find(params[:id])
  end
end
