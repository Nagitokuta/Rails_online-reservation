class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :yoga_class

  # バリデーション
  validates :user_id, presence: true
  validates :yoga_class_id, presence: true
  validates :user_id, uniqueness: { scope: :yoga_class_id, message: "は既にこのクラスを予約しています" }

  # スコープ
  scope :for_user, ->(user) { where(user: user) }
  scope :for_yoga_class, ->(yoga_class) { where(yoga_class: yoga_class) }
  scope :upcoming, -> { joins(:yoga_class).where("yoga_classes.start_time >= ?", Time.current) }
  scope :past, -> { joins(:yoga_class).where("yoga_classes.start_time < ?", Time.current) }
  scope :for_month, ->(year, month) {
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    joins(:yoga_class).where(yoga_classes: { start_time: start_date.beginning_of_day..end_date.end_of_day })
  }

  # メソッド
  def reservation_time
    created_at.strftime("%Y年%m月%d日 %H:%M")
  end
end
