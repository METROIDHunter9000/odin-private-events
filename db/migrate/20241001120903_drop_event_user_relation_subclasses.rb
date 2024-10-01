class DropEventUserRelationSubclasses < ActiveRecord::Migration[7.2]
  def up
    drop_table :rsvps
    drop_table :event_invitations
    drop_table :event_requests
  end

  def down
    create_table :rsvps do |t|
      t.belongs_to :user, null: false, foreign_key: { to_table: :users }
      t.belongs_to :event, null: false, foreign_key: { to_table: :events }
      t.index [:user_id, :event_id], unique: true
      t.timestamps
    end

    create_table :event_invitations do |t|
      t.belongs_to :user, null: false, foreign_key: { to_table: :users }
      t.belongs_to :event, null: false, foreign_key: { to_table: :events }
      t.index [:user_id, :event_id], unique: true
      t.timestamps
    end

    create_table :event_requests do |t|
      t.belongs_to :user, null: false, foreign_key: { to_table: :users }
      t.belongs_to :event, null: false, foreign_key: { to_table: :events }
      t.index [:user_id, :event_id], unique: true
      t.timestamps
    end

  end
end
