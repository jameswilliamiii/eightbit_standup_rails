module Api
  class StandupsController < Api::ApiController
    before_action :find_standup, only: [ :delete_attendee ]

    def index
      @standups = current_attendee.standups.not_completed
      render json: @standups, each_serializer: StandupSerializer, root: false, status: :ok and return
    end

    def delete_attendee
      if params[:attendees]
        remove_attendees
      else
        remove_current_attendee
      end
      render json: { success: true }
    end

    private

    def remove_attendees
      attendee_mentions = params[:attendees].split(',')
      attendee_mentions.each do |mention|
        if attendee = Attendee.find_by(hipchat_mention: mention.gsub('@', ''))
          @standup.remove_attendee(attendee)
        end
      end
    end

    def remove_current_attendee
      @standup.remove_attendee(current_attendee)
    end

  end
end