class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
    @users = User.default_users
  end

  private

  def require_admin
    return if current_admin?

    flash[:notice] = 'You are not authorized to access those pages'
    redirect_to root_path
  end
end
