namespace :reminders do
  desc "Send reminders for standups that have remind_at set for now"
  task :send_reminders => :environment do
    Standup.requires_reminder.each do |standup|
      if Rails.env.development?
        url = 'http://localhost:8080/reminder-hook'
      else
        url = 'http://192.241.185.166:8080/reminder-hook'
      end
      url << "?api_key=#{ENV['API_KEY']}"
      body = standup.attendees_missing_updates_hash.to_json
      begin
        HTTParty.post(url, body: body)
      rescue => e
        Rails.logger.info "Send Reminders Error: #{e.inspect}"
      end
    end
  end
end