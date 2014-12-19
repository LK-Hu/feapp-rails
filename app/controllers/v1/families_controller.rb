module V1
  class FamiliesController < ApplicationController
    def index
      families = {id: 1, email: 'xxx@xxx.com'}
      render json: families, status: 200
    end
  end
end