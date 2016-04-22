class StatusUpdate < ActiveRecord::Base

  belongs_to :attendee
  belongs_to :standup

  validates_presence_of :standup_id, :attendee_id, :status

end
