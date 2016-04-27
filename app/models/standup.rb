class Standup < ActiveRecord::Base

  belongs_to :user

  has_many :attendee_standups, dependent: :destroy
  has_many :attendees, through: :attendee_standups
  has_many :status_updates, dependent: :destroy

  validates_presence_of :user_id, :remind_at, :hipchat_room_name, :program_name

  def self.not_completed
    self.joins(:status_updates).where.not(status_updates: {created_at: Time.now.beginning_of_day..Time.now})
  end

  def remove_attendee(attendee)
    attendee_standup = self.attendee_standups.where attendee: attendee
    attendee_standup.destroy_all if attendee_standup
  end

end
