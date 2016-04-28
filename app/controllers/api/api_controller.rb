module Api
  class ApiController < ApplicationController
    respond_to :json

    before_action :api_auth
    before_action :check_and_assign_attendee

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

    def check_and_assign_attendee
      if !hipchat_params_present? || !current_attendee
        render json: {
          success: false,
          error: 'Sorry, we cannot identify you as a user'
        },
        status: :unprocessable_entity and return
      end
    end

    def hipchat_params_present?
      !params[:hipchat_id].blank?
    end

    def current_attendee
      @attendee ||= find_or_create_attendee
      @attendee.nil? ? false : @attendee
    end

    def find_or_create_attendee
      Attendee.includes(:standups).where(hipchat_id:  params[:hipchat_id]).first_or_create
    end

    def api_auth
      if params[:api_key].nil? || params[:api_key] != ENV['API_KEY']
        unauthorized_response
      end
    end

    def unauthorized_response
      render nothing: true, status: :unauthorized and return
    end

  end
end