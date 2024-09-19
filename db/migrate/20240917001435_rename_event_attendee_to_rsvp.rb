class RenameEventAttendeeToRsvp < ActiveRecord::Migration[7.2]
  def change
    rename_table :event_attendees, :rsvps
  end
end
