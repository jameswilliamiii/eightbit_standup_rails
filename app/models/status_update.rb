class StatusUpdate < ActiveRecord::Base

  belongs_to :attendee
  belongs_to :standup

  validates_presence_of :standup_id, :attendee_id, :status

  before_create :clean_text

  private

  def clean_text
    first_word = status.split(' ').first
    if first_word.gsub('-', '').downcase == 'standup'
      self.status = status.gsub("#{first_word} ", '')
    end
  end

end
