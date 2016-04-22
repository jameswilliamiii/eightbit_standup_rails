class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :hipchat_id
      t.string :hipchat_username

      t.timestamps null: false
    end
    add_index :attendees, :hipchat_id
  end
end
