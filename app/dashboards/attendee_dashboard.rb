require "administrate/base_dashboard"

class AttendeeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    attendee_standups: Field::HasMany,
    standups: Field::HasMany,
    status_updates: Field::HasMany,
    id: Field::Number,
    hipchat_id: Field::String,
    hipchat_username: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :hipchat_username,
    :standups,
    :status_updates,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :hipchat_id,
    :hipchat_username,
    :created_at,
    :updated_at,
    :standups,
    :status_updates,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :hipchat_id,
    :hipchat_username,
    :standups,
  ].freeze

  # Overwrite this method to customize how attendees are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(attendee)
    attendee.hipchat_username
  end
end
