module Api
  class StandupsController < Api::ApiController
    before_action :find_standup, only: [ :delete_attendee, :add_attendee ]

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

    def add_attendee
      if params[:attendees]
        add_attendees
      else
        add_current_attendee
      end
      render json: { success: true }
    end

    def create
      standup = Standup.find_or_initialize_by(hipchat_room_name: params[:hipchat_room_name])
      if standup.save
        render json: { success: true }
      else
        render json: { success: false, errors: standup.errors.full_messages.join(', ') }
      end
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

    def add_attendees
      attendee_mentions = params[:attendees].split(',')
      attendee_mentions.each do |mention|
        if attendee = Attendee.find_or_create_by(hipchat_mention: mention.gsub('@', ''))
          @standup.add_attendee(attendee)
        end
      end
    end

    def add_current_attendee
      @standup.add_attendee(current_attendee)
    end

  end
end