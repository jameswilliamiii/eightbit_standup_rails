module Api
  class StandupsController < Api::ApiController

    def index
      @standups = current_attendee.standups.not_completed
      render json: @standups, each_serializer: StandupSerializer, root: false, status: :ok and return
    end

  end
end