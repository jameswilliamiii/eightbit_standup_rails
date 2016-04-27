class Attendee < ActiveRecord::Base

  has_many :attendee_standups, dependent: :destroy
  has_many :standups, through: :attendee_standups
  has_many :status_updates, dependent: :destroy

  validates_presence_of :hipchat_id

end
