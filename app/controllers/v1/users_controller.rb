class V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:create]
  def show
    respond_with User.find(params[:id]) 
  end

  def create
    user = User.new(user_params) 
    if user.save
      render json: user , status: 201
      return 
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

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :user_name) 
    end
end
