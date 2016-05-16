class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string  :remind_at_day
      t.integer :remind_at_hour
      t.integer :standup_id

      t.timestamps null: false
    end
    add_index :reminders, :remind_at_day
    add_index :reminders, :remind_at_hour
    add_index :reminders, :standup_id
  end
end
