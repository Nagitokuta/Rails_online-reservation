# app/models/yoga_class.rb
class YogaClass < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :start_time, presence: true
  validates :instructor, presence: true, length: { maximum: 50 }
  validates :capacity, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  # ライブ配信ステータス
  enum live_status: {
    not_started: 0,    # 未開始
    waiting: 1,        # 待機中（配信開始前）
    live: 2,           # 配信中
    ended: 3,          # 終了
    cancelled: 4       # キャンセル
  }

  # 開始時刻が現在時刻より未来であることをチェック
  validate :start_time_must_be_future

  # 予約関連のアソシエーション
  has_many :reservations, dependent: :destroy
  has_many :users, through: :reservations

  has_many :live_participations, dependent: :destroy

  has_many :feedbacks, dependent: :destroy

  # スコープ
  scope :upcoming, -> { where("start_time >= ?", Time.current) }
  scope :past, -> { where("start_time < ?", Time.current) }

  # メソッド
  def reserved_count
    reservations.count
  end

  def available_spots
    capacity - reserved_count
  end

  def full?
    reserved_count >= capacity
  end

  def available?
    !full? && start_time > Time.current
  end

  def can_join_live?
    (waiting? || live?) && youtube_live_id.present?
  end

  def live_available_for_user?(user)
    return false unless can_join_live?
    reservations.exists?(user: user)
  end

  def should_start_soon?
    start_time <= 30.minutes.from_now && start_time > Time.current
  end

  def is_live_time?
    start_time <= Time.current && start_time >= 2.hours.ago
  end

  def feedback_count
    feedbacks.count
  end

  def rating_distribution
    (1..5).map do |rating|
      {
        rating: rating,
        count: feedbacks.by_rating(rating).count,
        percentage: feedbacks.empty? ? 0 : (feedbacks.by_rating(rating).count.to_f / feedbacks.count * 100).round(1)
      }
    end.reverse
  end

  def start_time_must_be_future
    return unless start_time.present?

    if start_time <= Time.current
      errors.add(:start_time, "は現在時刻より未来の時刻を設定してください")
    end
  end

  def current_participants_count
    live_participations.active.count
  end

  def current_participants
    User.joins(:live_participations)
        .where(live_participations: { yoga_class: self, left_at: nil })
  end

  def average_rating
    return 0 if feedbacks.empty?
    (feedbacks.average(:rating) || 0).round(1)
  end

  private
end
