class Standup < ActiveRecord::Base

  belongs_to :user

  has_many :attendee_standups, dependent: :destroy
  has_many :attendees, through: :attendee_standups
  has_many :status_updates, dependent: :destroy

  validates_presence_of :user_id, :remind_at, :hipchat_room_name, :program_name

  before_save :add_remind_at_info

  class << self
    def requires_reminder
      remind_at_day = Time.now.strftime('%A')
      remind_at_hour = Time.now.hour
      where(remind_at_hour: remind_at_hour, remind_at_day: remind_at_day).where('end_at IS ? OR end_at > ?', nil, Time.now)
    end

    def not_completed
      completed = self.joins(:status_updates).where(status_updates: {created_at: todays_time_range})
      completed = completed.uniq.select(:id)
      where.not id: completed
    end

    def todays_time_range
      Time.now.beginning_of_day..Time.now.end_of_day
    end
  end

  def remove_attendee(attendee)
    attendee_standup = self.attendee_standups.where attendee: attendee
    attendee_standup.destroy_all if attendee_standup
  end

  def attendees_missing_updates
    completed = attendees.joins(:status_updates).where(status_updates: {created_at: self.class.todays_time_range})
    completed = completed.uniq.select(:id)
    attendees.where.not id: completed
  end

  def attendees_missing_updates_hash
    hash = {
      attendees:[]
    }
    attendees_missing_updates.each do |a|
      attendee_hash = {
        hipchat_id: a.hipchat_id,
        program_name: self.program_name
      }
      hash[:attendees] << attendee_hash
    end
    return hash
  end

  private

  def add_remind_at_info
    if !remind_at.blank?
      self.remind_at_day = remind_at.strftime('%A')
      self.remind_at_hour = remind_at.hour
    end
  end

end
