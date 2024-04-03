class Admin::UsersController < ApplicationController
  before_action :require_admin

  def show
    @user = User.find(params[:id])
  end

  private

  def require_admin
    return if current_admin?

    flash[:notice] = 'Your are not authorized to access those pages'
    redirect_to root_path
  end
end
