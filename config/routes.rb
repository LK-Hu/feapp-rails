Rails.application.routes.draw do
	devise_for :users, controllers: { sessions: 'sessions'}, defaults: { format: 'json' }
	devise_scope :user do
	  namespace :v1, defaults: { format: :json } do
		resources :families
		resources :users
		resources :sessions
		
		post 'families/join', to: 'families#join'
		post 'families/leave', to: 'families#leave'
		get 'families/user_families/:id', to: 'families#user_families'
		get 'users/family_users/:id', to: 'users#family_users'
		
	  end
	end
end
