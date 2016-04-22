class CreateAttendeeStandups < ActiveRecord::Migration
  def change
    create_table :attendee_standups do |t|
      t.integer :attendee_id, null: false
      t.integer :standup_id, null: false

      t.timestamps null: false
    end
    add_index :attendee_standups, :attendee_id
    add_index :attendee_standups, :standup_id
  end
end
