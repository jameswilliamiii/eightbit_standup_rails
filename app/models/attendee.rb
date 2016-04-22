class Attendee < ActiveRecord::Base

  has_many :attendee_standups, dependent: :destroy
  has_many :standups, through: :attendee_standups

end
