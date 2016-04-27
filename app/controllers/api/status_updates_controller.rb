module Api
  class StatusUpdatesController < Api::ApiController

    before_action :find_standup
    before_action :add_to_standup
    before_action :add_name_to_attendee

    def index
      @status_updates = @standup.status_updates.group_by_attendee(params[:date])
      render json: @status_updates, root: false, status: :ok and return
    end

    def create
      @status_update = current_attendee.status_updates.new(standup: @standup, status: params[:status])
      if @status_update.save
        render json: {success: true}, status: :ok and return
      else
        render json: {success: false, error: @status_update.errors.full_messages.join('. ')}
      end
    end

    private

    def add_to_standup
      if !current_attendee.standups.include?(@standup)
        current_attendee.standups << @standup
        current_attendee.save
      end
    end

    def add_name_to_attendee
      if current_attendee.hipchat_username.blank? || current_attendee.hipchat_mention.blank?
        current_attendee.update_columns(
          hipchat_username: params[:hipchat_username],
          hipchat_mention: params[:hipchat_mention]
        )
      end
    end

  end
end