class CreateEverything < ActiveRecord::Migration[7.2]
  def up
    create_table :users do |t|
      t.string :username, limit: 30

      t.timestamps
    end
    add_index :users, :username, unique: true

    create_table :events do |t|
      t.belongs_to :organizer, null: false, foreign_key: { to_table: :users }

      t.string :title, limit: 50, null: false
      t.string :body, null: false
      t.datetime :date, null: false

      t.timestamps
    end

    create_join_table :attendees, :events, table_name: :event_attendees
    add_foreign_key :event_attendees, :users, column: :attendee_id
    add_foreign_key :event_attendees, :events
  end
  
  def down
    drop_table :event_attendees
    drop_table :users
    drop_table :events
  end
end
