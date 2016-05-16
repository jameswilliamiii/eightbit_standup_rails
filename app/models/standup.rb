class Standup < ActiveRecord::Base

  belongs_to :user

  has_many :attendee_standups, dependent: :destroy
  has_many :attendees, through: :attendee_standups
  has_many :status_updates, dependent: :destroy
  has_many :reminders, dependent: :destroy

  attr_accessor :remind_at

  validates_presence_of :user_id, :hipchat_room_name, :program_name

  before_save :create_reminder

  class << self
    def requires_reminder
      remind_at_day = Time.now.strftime('%A')
      remind_at_hour = Time.now.hour
      joins(:reminders).where(reminders: {remind_at_hour: remind_at_hour, remind_at_day: remind_at_day}).where('end_at IS ? OR end_at > ?', nil, Time.now)
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

  def remind_at=(value)
    attribute_will_change!("remind_at") unless @remind_at.blank?
    @remind_at = value
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

  def create_reminder
    if !self.remind_at.blank?
      remind_at = DateTime.parse(self.remind_at)
      self.reminders.first_or_create remind_at_day: remind_at.strftime('%A'), remind_at_hour: remind_at.hour
    end
  end

end
