class V1::UsersController < ApplicationController

  def index
    begin
      if params[:user_name] == current_user.user_name
        respond_with current_user, status: 200
      else
        render json: User.all, status: 200
      end
    rescue Exception
      nil
    end
  end

  def show
    respond_with User.find(params[:id]), status: 200
  end

  def create
    user = User.new(user_params) 
    if user.save
		if user.role=="child"
		  account_params = { :user_id=>user.id, :account_type=>"savings" }
		  account = Account.new(account_params) 
		  if account.save
			render json: user , status: 201
			return 
		  else
			render json: { errors: account.errors }, status: 422
		  end
		else
			render json: user , status: 201
		end
	else
		render json: { errors: user.errors }, status: 422
	end
  end

  def update
    user = current_user

    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
	User.find(params[:id]).destroy
    #current_user.destroy
    head 204
  end
  
  def family_users
	users = Family.find(params[:id]).users
	render json: users, status: 200
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :user_name) 
    end
end
