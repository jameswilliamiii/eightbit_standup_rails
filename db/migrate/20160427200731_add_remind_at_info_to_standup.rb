class AddRemindAtInfoToStandup < ActiveRecord::Migration
  def change
    add_column :standups, :remind_at_day, :string
    add_column :standups, :remind_at_hour, :integer
  end
end
