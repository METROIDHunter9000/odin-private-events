# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

test_password = "password"

EventUserRelation.delete_all
Event.delete_all
User.delete_all

user1 = User.new do |u|
  u.email = "person1@email.com"
  u.username = "person1"
  u.password = test_password
  u.password_confirmation = test_password 
end
user1.save!

user2 = User.new do |u|
  u.email = "person2@email.com"
  u.username = "person2"
  u.password = test_password
  u.password_confirmation = test_password
end
user2.save!

user3 = User.new do |u|
  u.email = "person3@email.com"
  u.username = "person3"
  u.password = test_password
  u.password_confirmation = test_password
end
user3.save!

# user 1 has all public events
event_snail = Event.create(title: "Snail Eating Contest", 
                        body: "Whoever eats 50 snails fastest wins a PS5",
                        organizer_id: user1.id,
                        date: "2024-09-20",
                        is_private: false)
event_paint = Event.create(title: "Group Paint Drying Session", 
                        body: "We're gonna watch paint dry! Fasten your seatbelts!!!",
                        organizer_id: user1.id,
                        date: "2024-11-02",
                        is_private: false)

# user 2 has all private events
event_trem = Event.create(title: "Tremulous LAN party", 
                        body: "Hosting Tremulous LAN party - bring your PC! Snacks provided!",
                        organizer_id: user2.id,
                        date: "2025-01-11",
                        is_private: true)
event_wedding = Event.create(title: "Wedding Receiption", 
                        body: "William & Katy are getting married!!!",
                        organizer_id: user2.id,
                        date: "2025-04-20",
                        is_private: true)

# user 3 only attends events
Rsvp.create!(user_id: user3.id, event_id: event_snail.id)
EventInvitation.create!(user_id: user3.id, event_id: event_trem.id)
EventRequest.create!(user_id: user3.id, event_id: event_wedding.id)
