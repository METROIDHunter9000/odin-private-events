class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"

  has_many :event_user_relations
  has_many :event_attendees
  has_many :attendees, class_name: "User", through: :event_attendees, source: :attendee

  validates :title, presence: true, length: {maximum: 50}
  validates :body, presence: true, length: {minimum: 3}
  validates :date, presence: true
  validates :is_private, inclusion: {in: [true, false]}

  scope :past, -> { where("date <= ?", DateTime.now)}
  scope :future, -> { where("date > ?", DateTime.now)}
  scope :upcoming, -> { future.limit(3) }
  
  def to_s
    self.title
  end
end
