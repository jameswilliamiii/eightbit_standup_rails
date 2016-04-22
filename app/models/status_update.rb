class StatusUpdate < ActiveRecord::Base

  belongs_to :attendee
  belongs_to :standup

end
