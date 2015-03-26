Rails.application.routes.draw do
	devise_for :users, controllers: { sessions: 'sessions'}, defaults: { format: 'json' }
	devise_scope :user do
	  namespace :v1, defaults: { format: :json } do
		resources :families
		resources :accounts
		resources :users
		resources :sessions
		
		post 'families/join', to: 'families#join'
		post 'families/leave', to: 'families#leave'
		get 'families/user_families/:id', to: 'families#user_families'
		get 'users/family_users/:id', to: 'users#family_users'
		get 'accounts/user_accounts/:id', to: 'accounts#user_accounts'
		post 'accounts/deposit', to: 'accounts#deposit'
		post 'accounts/withdraw', to: 'accounts#withdraw'
		post 'accounts/transfer', to: 'accounts#transfer'
		get 'transactions/user_transactions/:id', to: 'transactions#user_transactions'
		get 'transactions/account_transactions/:id', to: 'transactions#account_transactions'
		get 'transactions/approver_transactions/:id', to: 'transactions#approver_transactions'
	  end
	end
end
