module Api
  class ApiController < ApplicationController
    respond_to :json

    before_action :check_and_assign_attendee

    private

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

  end
end