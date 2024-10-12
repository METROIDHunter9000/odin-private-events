class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # Remember to establish relationships between models both ways!
  # Declaring that a user "has many" event user relations give us
  # the power to cleanly join the tables & perform queries
  has_many :event_user_relations

  has_many :organized_events, class_name: "Event"

  has_many :event_attendees, foreign_key: :user_id
  has_many :attending_events, class_name: "Event", through: :event_attendees

  validates :username, presence: true, length: {maximum: 30}

  def to_s
    self.username
  end
end
