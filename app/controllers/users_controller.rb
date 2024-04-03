class UsersController < ApplicationController
  before_action :require_user, except: %i[new create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    movie_service = MovieService.new
    @image_base_url = movie_service.get_image_base_url

    @movie_info = {}
    @user.viewing_parties.each do |party|
      next if party.movie_id.nil?

      movie = movie_service.movie_details(party.movie_id)

      @movie_info[party.id] = {
        title: movie.title,
        poster: @image_base_url + movie.poster
      }
    end
  end

  def create
    user_params[:email] = user_params[:email].downcase
    user = User.new(user_params)
    #  if user.password == user.password_confirmation
    if user.save
      session[:user_id] = user.id
      flash[:success] = 'Successfully Created New User'
      redirect_to user_path(user)
    else
      flash[:error] = "#{error_message(user.errors)}"
      redirect_to register_user_path
    end
    #  else
    #    flash[:error] = 'Password and password confirmation do not match'
    #    redirect_to register_user_path
    #  end
  end

  # def login_form; end

  # def login
  #   user = User.find_by(email: params[:email])
  #   if user && user.authenticate(params[:password])
  #     cookies[:location] = params[:location]
  #     flash[:success] = "Welcome, #{user.name}"
  #     redirect_to user_path(user)
  #   else
  #     flash[:error] = 'Sorry, your credentials are bad.'
  #     render :login_form
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def require_user
    user_id = params[:id]
    return if current_user && current_user.id == user_id.to_i

    flash[:notice] = "You must be logged in or registered to access a user's dashboard"
    redirect_to root_path
  end
end
