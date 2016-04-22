class Standup < ActiveRecord::Base

  has_many :attendee_standups, dependent: :destroy
  has_many :attendees, through: :attendee_standups

end
