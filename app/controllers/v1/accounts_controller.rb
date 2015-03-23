class V1::AccountsController < ApplicationController
prepend_before_action :authenticate_user!, :except => [:create, :user_accounts]

  def show
    respond_with Account.find(params[:id]) 
  end

  def create
    account = Account.new(account_params) 
    if account.save
      render json: account , status: 201
      return 
    else
      render json: { errors: account.errors }, status: 422
    end
  end

  def update
    account = Account.find(params[:id]) 

    if account.update(account_params)
      render json: account, status: 200
    else
      render json: { errors: account.errors }, status: 422
    end
  end

  def destroy
	account.find(params[:id]).destroy
    head 204
  end
  
  def user_accounts
    accounts = User.find(params[:id]).accounts
	render json: accounts, status: 200
  end
  
  private

    def account_params
      params.require(:account).permit(:user_id, :account_type, :balance, :interest, :interest_period, :total_credit) 
    end
end