class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  has_many :organized_events, class_name: "Event"

  has_many :event_attendees, foreign_key: :attendee_id
  has_many :attending_events, class_name: "Event", through: :event_attendees

  validates :username, presence: true, length: {maximum: 30}

  def to_s
    self.username
  end
end
