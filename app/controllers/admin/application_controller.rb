# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_filter :authenticate_admin

    helper_method :sidebar_resources

    def authenticate_admin
      if !current_user
        redirect_to new_user_session_path, alert: 'You must be signed in to view this page'
      end
    end

    def sidebar_resources
      # All resources that you want shown in sidebar nav.
      [
        {class: :standups},
        {class: :attendees},
        {class: :status_updates},
        {class: :users},
      ]
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
