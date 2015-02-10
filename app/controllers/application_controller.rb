class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  respond_to :json

  def authenticate_user_from_token!
    authenticate_with_http_token do |token, options|
      user_name = options[:user_name].presence
      user = user_name && User.find_by_user_name(user_name)

      # Notice how we use Devise.secure_compare to compare the token
      # in the database with the token given in the params, mitigating
      # timing attacks
      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in(user, store: false)
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:user_name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:user_name, :password) }
  end
end
