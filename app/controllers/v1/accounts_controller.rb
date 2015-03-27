class V1::AccountsController < ApplicationController
prepend_before_action :authenticate_user!, :except => [:create, :user_accounts, :deposit, :withdraw, :transfer]

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
  

  def deposit
	account = Account.find(params[:account][:id])
	if(account.balance==nil)
		account.balance=0;
	end	
	account.balance += params[:account][:amount].to_i
	if account.save
		# record transaction
      render json: account, status: 200
    else
      render json: { errors: account.errors }, status: 422
    end
  end
  
  def withdraw
  	account = Account.find(params[:account][:id])
	if(account.balance==nil)
		account.balance=0;
	end	
	account.balance -= params[:account][:amount].to_i
	if account.save
		# record transaction
      render json: account, status: 200
    else
      render json: { errors: account.errors }, status: 422
    end
  end
    
  def transfer
	account1 = Account.find(params[:account][:id1])
	account2 = Account.find(params[:account][:id2])
	if(account1.balance==nil)
		account1.balance=0;
	end	
	if(account2.balance==nil)
		account2.balance=0;
	end	
	
	account1.balance -= params[:account][:amount].to_i
	account2.balance += params[:account][:amount].to_i	
	if account1.balance < 0
		render json: "not enough money in account", status: 422
		return
	end
	
	if account1.save
		if account2.save
			# record transaction
			render json: [account1, account2], status: 200
		else
			render json: { errors: account2.errors }, status: 422
		end
    else
      render json: { errors: account1.errors }, status: 422
    end
  end

=begin   
  def record_transaction
	transaction_params = { :user_id=>account.id, :transaction_type=>"deposit" }
	transaction = Transaction.new(Transaction_params) 
	if transaction.save
		render json: account , status: 200
		return 
	else
		render json: { errors: transaction.errors }, status: 422
	end 
  end
  


  def interest
    accounts = User.find(params[:id]).accounts
	now = DateTime.now;
	
	accounts.each do |a| # update accumulated_interest of each of user's account
		interest_days=0; # number of days in the interest period
		case a.interest_period
			when "Daily"
				interest_days=1
			when "Weekly"
				interest_days=7
			when "Monthly"
				interest_days=days_in_month(now.month)
			when "Yearly"
				interest_days=days_in_year(now.year)
			else
				continue
		end
		
		days_elapsed=(now-a.last_interest).to_i / 1.day; # number of days passed since last interest update
		if(a.interest_rate>0 && days_elapsed>=interest_days) # has interest and days passed is greater than 1 interest period
			for(i=0; i<days_elapsed; i+=interest_days) # each interest period since last update
				a.accumulated_interest = (a.balance+a.accumulated_interest)*(1.0 + a.interest_rate/100.0) # interest accumulated at the period
				# record transaction
			end
			a.last_interest = a.last_interest.to_i + interest_days*1.day*i;	# end of last interest period	
			if a.update(account_params)
				# record transaction
			  render json: account, status: 200
			else
			  render json: { errors: account.errors }, status: 422
			end
		end
	end
	render json: accounts, status: 200
  end
=end  

  private

    def account_params
      params.require(:account).permit(:user_id, :account_type, :balance, :accumulated_interest, :interest_rate, :interest_period, :total_credit, :amount) 
    end
end