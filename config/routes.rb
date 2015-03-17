Rails.application.routes.draw do
	devise_for :users, :controllers => { sessions: 'sessions', registrations: 'registrations' }
	devise_scope :user do
	  namespace :v1, defaults: { format: :json } do
		resources :families
		resources :users
		resources :sessions
	  end
	end
end
