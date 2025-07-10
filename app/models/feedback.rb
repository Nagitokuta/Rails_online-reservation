# app/models/feedback.rb
class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :yoga_class

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :user_id, uniqueness: { scope: :yoga_class_id, message: "このクラスには既にフィードバックを送信済みです" }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_rating, ->(rating) { where(rating: rating) }

  def rating_stars
    "★" * rating + "☆" * (5 - rating)
  end

  def rating_text
    case rating
    when 5 then "とても良い"
    when 4 then "良い"
    when 3 then "普通"
    when 2 then "悪い"
    when 1 then "とても悪い"
    end
  end
end
