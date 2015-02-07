class V1::SessionsController < Devise::SessionsController  
  prepend_before_filter :require_no_authentication, :only => [:create ]
  before_filter :ensure_params_exist

  respond_to :json
  skip_before_filter :verify_authenticity_token

  def show
	respond_with User.find_by_authentication_token(params[:id])
  end
  
  def create
    resource = User.find_for_database_authentication(:email => params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      resource.ensure_authentication_token
	  resource.save
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :email=>resource.email}
      return
    end
    invalid_login_attempt
  end


  def destroy  
	token=params[:authentication_token]
	user = User.find_by_authentication_token(token)
	user.authentication_token=nil;
	token_deleted=user.save
    signed_out = sign_out(user)
	
    if signed_out && token_deleted
      render json: "Successfully logged out", status: 200
    else
      render json: "Error logging out", status: 400
    end
  end  

  
protected
  def user_params
    params[:user].permit(:email, :password, :password_confirmation)
  end

  def ensure_params_exist
    return #unless params[:email].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end