# app/controllers/feedbacks_controller.rb
class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_yoga_class
  before_action :check_reservation, only: [ :new, :create ]
  before_action :check_existing_feedback, only: [ :new, :create ]

  def new
    @feedback = @yoga_class.feedbacks.build
  end

  def create
    @feedback = @yoga_class.feedbacks.build(feedback_params)
    @feedback.user = current_user

    if @feedback.save
      redirect_to @yoga_class, notice: "フィードバックを送信しました。ありがとうございました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @feedback = @yoga_class.feedbacks.find(params[:id])

    # 自分のフィードバックまたは管理者のみ閲覧可能
    unless @feedback.user == current_user || current_user.admin?
      redirect_to @yoga_class, alert: "このフィードバックを閲覧する権限がありません。"
    end
  end

  private

  def set_yoga_class
    @yoga_class = YogaClass.find(params[:yoga_class_id])
  end

  def check_reservation
    unless current_user.reservations.exists?(yoga_class: @yoga_class)
      redirect_to @yoga_class, alert: "このクラスを予約していないため、フィードバックを送信できません。"
    end
  end

  def check_existing_feedback
    if current_user.has_feedback_for?(@yoga_class)
      redirect_to @yoga_class, alert: "このクラスには既にフィードバックを送信済みです。"
    end
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :comment)
  end
end
