# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_feapp_session'

# For API server, Rails application should not issue session cookies but authentication should be done exclusively via the authentication token.
Rails.application.config.session_store :disabled
