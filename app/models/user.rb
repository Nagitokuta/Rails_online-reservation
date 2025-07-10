class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, uniqueness: true

  # 予約関連のアソシエーション
  has_many :reservations, dependent: :destroy
  has_many :yoga_classes, through: :reservations

  has_many :live_participations, dependent: :destroy

  has_many :feedbacks, dependent: :destroy

  # メソッド
  def reserved_yoga_class?(yoga_class)
    yoga_classes.include?(yoga_class)
  end

  def reservation_for(yoga_class)
    reservations.find_by(yoga_class: yoga_class)
  end

  def participating_in?(yoga_class)
    live_participations.active.exists?(yoga_class: yoga_class)
  end

  def feedback_for(yoga_class)
    feedbacks.find_by(yoga_class: yoga_class)
  end

  def has_feedback_for?(yoga_class)
    feedbacks.exists?(yoga_class: yoga_class)
  end
end
