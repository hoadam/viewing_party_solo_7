class WelcomeController < ApplicationController
  def index
    @users = User.all if current_user
  end
end
