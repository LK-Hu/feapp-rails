# We need to overload Devise's RegistrationsController and tell it to accept JSON.
# http://blog.andrewray.me/how-to-set-up-devise-ajax-authentication-with-rails-4-0/
class RegistrationsController < Devise::RegistrationsController
  # Stop static pages from users/sign_up
  clear_respond_to
  # RegistrationsController accept JSON
  respond_to :json
end