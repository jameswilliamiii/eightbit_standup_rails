class Standup < ActiveRecord::Base

  has_many :attendee_standups, dependent: :destroy
  has_many :attendees, through: :attendee_standups
  has_many :status_updates, dependent: :destroy

end
