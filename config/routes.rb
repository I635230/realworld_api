Rails.application.routes.draw do
  scope :api do
    post "/users/login", to: "authentications#create"
    resources :users, only: %i[create]
    resources :articles, only: %i[create]
  end
end
