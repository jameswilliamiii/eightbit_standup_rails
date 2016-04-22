FactoryGirl.define do
  factory :status_update do
    attendee
    standup
    status "MyText"
  end

end
