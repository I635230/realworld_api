Rails.application.routes.draw do
  scope :api do
    resources :users, only: %i[create]
  end
end
