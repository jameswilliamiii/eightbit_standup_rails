class RemoveReminderColumnsFromStandup < ActiveRecord::Migration
  def change
    remove_column :standups, :remind_at
    remove_column :standups, :remind_at_day
    remove_column :standups, :remind_at_hour
  end
end
