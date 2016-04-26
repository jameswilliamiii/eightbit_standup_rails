module Api
  class StatusUpdatesController < Api::ApiController

    before_action :find_standup

    def create
      @status_update = current_attendee.status_updates.new(standup: @standup, status: params[:status])
      if @status_update.save
        render json: {success: true}, status: :ok and return
      else
        render json: {success: false, error: @status_update.errors.full_messages.join('. ')}
      end
    end

    private

    def find_standup
      @standup = Standup.find_by hipchat_room_name: params[:hipchat_room_name]
      unless @standup
        render json: {
          success: false,
          error: 'Sorry, we cannot find a stand-up associated with this chat room'
        },
        status: :unprocessable_entity and return
      end
    end

  end
end