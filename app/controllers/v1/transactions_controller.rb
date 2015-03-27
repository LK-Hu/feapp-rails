class V1::TransactionsController < ApplicationController
prepend_before_action :authenticate_user!, :except => [:create, :user_transactions, :account_transactions, :approver_transactions]

    def show
    respond_with Transaction.find(params[:id]) 
  end

  def create
    transaction = Transaction.new(transaction_params) 
    if transaction.save
      render json: transaction , status: 201
      return 
    else
      render json: { errors: transaction.errors }, status: 422
    end
  end

  def update
    transaction = Transaction.find(params[:id]) 

    if transaction.update(transaction_params)
      render json: transaction, status: 200
    else
      render json: { errors: transaction.errors }, status: 422
    end
  end

  def destroy
	transaction.find(params[:id]).destroy
    head 204
  end
  
  # transactions of child
  def user_transactions
	transactions = User.find(params[:id]).transactions
	render json: transactions, status: 200
  end
  
  def account_transactions
	transactions = Account.find(params[:id]).transactions
	render json: transactions, status: 200
  end
  
  # transactions approved by the parent with id of :id
  def approver_transactions
	transactions = Transaction.find_by approver_id: params[:id]
	render json: transactions, status: 200
  end
  
  private

    def transaction_params
      params.require(:transaction).permit(:user_id, :account_id, :approver_id, :transaction_type, :amount, :transaction_time) 
    end
end