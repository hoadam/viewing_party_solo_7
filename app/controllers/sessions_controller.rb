class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      cookies[:location] = params[:location]
      flash[:success] = "Welcome, #{user.name}"

      if user.admin?
        redirect_to admin_dashboard_path
      else
        redirect_to user_path(user)
      end
    else
      flash[:error] = 'Sorry, your credentials are bad.'
      redirect_to user_login_path
    end
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end
end
