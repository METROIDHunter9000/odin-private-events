class CreateEventUser < ActiveRecord::Migration[7.2]
  def change
    create_table :event_user_relations do |t|
      t.belongs_to :user, null: false, foreign_key: { to_table: :users }
      t.belongs_to :event, null: false, foreign_key: { to_table: :events }
      t.string :type, null: false
      t.index [:user_id, :event_id], unique: true
      t.index [:user_id, :event_id, :type], unique: true
      t.timestamps
    end

    rename_column :rsvps, :attendee_id, :user_id
  end
end
