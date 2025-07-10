# app/models/live_participation.rb
class LiveParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :yoga_class

  validates :joined_at, presence: true

  scope :active, -> { where(left_at: nil) }
  scope :for_class, ->(yoga_class) { where(yoga_class: yoga_class) }

  def duration
    return 0 unless joined_at

    end_time = left_at || Time.current
    ((end_time - joined_at) / 1.minute).round
  end

  def active?
    joined_at.present? && left_at.nil?
  end
end
