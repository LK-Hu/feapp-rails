Rails.application.routes.draw do
	devise_for :users
	devise_scope :user do
	  namespace :v1, defaults: { format: :json } do
		resources :families
		resources :users
		resources :sessions
	  end
	end
end
