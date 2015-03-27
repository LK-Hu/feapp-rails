class V1::FamiliesController < ApplicationController
prepend_before_action :authenticate_user!, :except => [:create, :join, :leave, :user_families]

    def show
    respond_with Family.find(params[:id]) 
  end

  def create
    family = Family.new(family_params) 
    if family.save
      render json: family , status: 201
      return 
    else
      render json: { errors: family.errors }, status: 422
    end
  end

  def update
    family = Family.find(params[:id]) 

    if family.update(family_params)
      render json: family, status: 200
    else
      render json: { errors: family.errors }, status: 422
    end
  end

  def destroy
	family.find(params[:id]).destroy
    head 204
  end
  
  def join
	family = Family.find(params[:family_id])
    user = User.find(params[:user_id])

    # Register a client if it is not registered already
    unless user.families.include?(family)
      # Add vendor to a client's vendor list
      family.users << user
      render json: "User joined family", status: 200
    else
      render json: "User already joined family", status: 400
    end
   end
  
  def leave
	 user = User.find(params[:user_id])
     family = user.families.find(params[:family_id])

     if family
        user.families.delete(family)
		render json: "User left family", status: 200
	 else
		render json: "User already left family", status: 400
     end
  end
  
  def user_families
	families = User.find(params[:id]).families
	render json: families, status: 200
  end
  
  private

    def family_params
      params.require(:family).permit(:family_name) 
    end
end