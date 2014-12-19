Rails.application.routes.draw do
  namespace :v1 do
    resources :families
    resources :users
  end
end
