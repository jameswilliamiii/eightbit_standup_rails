class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.integer :attendee_id, null: false
      t.integer :standup_id, null: false
      t.text :status

      t.timestamps null: false
    end
    add_index :status_updates, :attendee_id
    add_index :status_updates, :standup_id
  end
end
