Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :attendees
    resources :attendee_standups
    resources :standups
    resources :status_updates

    root to: "standups#index"
  end

  devise_for :users, skip: [:registrations]

  resource :users,
      only: [:edit, :update, :destroy],
      controller: 'devise/registrations',
      as: :user_registration do
    get 'cancel'
  end

  root to: "admin/standups#index"
end
