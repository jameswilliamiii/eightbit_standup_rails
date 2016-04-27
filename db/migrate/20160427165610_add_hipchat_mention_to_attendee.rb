class AddHipchatMentionToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :hipchat_mention, :string
  end
end
