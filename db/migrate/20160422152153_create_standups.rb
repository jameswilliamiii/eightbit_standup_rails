class CreateStandups < ActiveRecord::Migration
  def change
    create_table :standups do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at
      t.datetime :remind_at, null: false
      t.string   :hipchat_room_name, null: false
      t.integer  :user_id, null: false
      t.string   :program_name, null: false

      t.timestamps null: false
    end
    add_index :standups, :user_id
    add_index :standups, :remind_at
    add_index :standups, :program_name
  end
end
