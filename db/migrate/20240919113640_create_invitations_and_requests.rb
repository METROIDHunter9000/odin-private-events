class CreateInvitationsAndRequests < ActiveRecord::Migration[7.2]
  def change
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
