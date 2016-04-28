class StatusUpdate < ActiveRecord::Base

  belongs_to :attendee
  belongs_to :standup

  validates_presence_of :standup_id, :attendee_id, :status

  before_create :clean_text

  private

  def clean_text
    first_word = status.split(' ').first
    if first_word.gsub('-', '').downcase == 'standup'
      self.status = status.sub("#{first_word} ", '')
    end
  end

  def self.group_by_attendee(date=nil)
    date = if date
      Time.parse(date)
    else
      Time.now
    end
    results = includes(:attendee).where(created_at: date.beginning_of_day..date.end_of_day)
    results = results.order('created_at asc')
    results = results.group_by(&:attendee)
    results.inject([]){ |result, (a, su)| result << {"#{a.hipchat_username}" => su} }
  end

end
