class AddIndexAndIdToRsvps < ActiveRecord::Migration[7.2]
  def change
    add_index :rsvps, :event_id
    add_index :rsvps, :attendee_id
    add_index :rsvps, [:event_id, :attendee_id], unique: true
    #change_table :rsvps do |t|
    #  t.primary_key [:event_id, :attendee_id]
    #end
  end
end
