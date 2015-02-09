# Devise::SessionController handles the creating and destroying of logging in user sessions for your application. 
# Here. We override Devise::SessionsController to handle user authentication via API.
# Ref: http://soryy.com/blog/2014/apis-with-devise/
class V1::SessionsController < Devise::SessionsController 
  prepend_before_action :require_no_authentication, :only => [:create, :new]
  skip_before_action :verify_authenticity_token

  def show
	respond_with User.find_by_authentication_token(params[:id])
  end

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    # respond_with(resource, serialize_options(resource))
    render json: { success: true, auth_token: resource.authentication_token, email: resource.email }, status: 201
  end
  
  def create
    # build resource
    self.resource = resource_from_credentials
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      render json: { success: true, auth_token: resource.authentication_token, email: resource.email }, status: 201
    else
      invalid_login_attempt
    end
  end


  def destroy  
  	user = User.find_by_authentication_token(request.headers['X-API-TOKEN'])
  	if user
      user.reset_authentication_token!
      render json: { message: 'session deleted.', success: true }, status: 204 
    else
      render json: { message: 'Invalid token'}, status: 404
    end
  end  

  
protected

  def invalid_login_attempt
    warden.custom_failure!
    render json: { success: false, message: "Error with your login or password" }, status: 401
  end

  def resource_from_credentials
    data = { email: params[:user][:email]}
    if res = resource_class.find_for_database_authentication(data)
      if res.valid_password?(params[:user][:password])
        res
      end
    end
  end
end