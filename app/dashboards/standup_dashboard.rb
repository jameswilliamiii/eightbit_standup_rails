require "administrate/base_dashboard"

class StandupDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    attendee_standups: Field::HasMany,
    attendees: Field::HasMany,
    status_updates: Field::HasMany,
    id: Field::Number,
    end_at: Field::DateTime,
    remind_at: Field::DateTime,
    hipchat_room_name: Field::String,
    user: Field::BelongsTo,
    program_name: Field::String,
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
    :program_name,
    :attendees,
    :remind_at,
    :end_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :program_name,
    :hipchat_room_name,
    :user,
    :attendees,
    :status_updates,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :program_name,
    :remind_at,
    :end_at,
    :hipchat_room_name,
    :attendees,
    :user,
  ].freeze

  # Overwrite this method to customize how standups are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(standup)
    standup.program_name
  end
end
