class RemoveStartAtFromStandup < ActiveRecord::Migration
  def change
    remove_column :standups, :start_at
  end
end
