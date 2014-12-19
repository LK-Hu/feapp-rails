module V1
  class UsersController < ApplicationController
    def index
      users = {id: 1, email: 'xxx@xxx.com'}
      render json: users, status: 200
    end
  end
end