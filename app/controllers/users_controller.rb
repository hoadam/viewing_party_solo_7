class UsersController < ApplicationController
   def new
      @user = User.new
   end

   def show
      @user = User.find(params[:id])
      movie_service = MovieService.new
      @image_base_url = movie_service.get_image_base_url

      @movie_info = {}
      @user.viewing_parties.each do |party|
         if party.movie_id != nil

            movie = movie_service.movie_details(party.movie_id)

            @movie_info[party.id] = {
               title: movie.title,
               poster: @image_base_url + movie.poster
            }
         end
      end
   end

   def create
      user = User.new(user_params)
      if user.save
         flash[:success] = 'Successfully Created New User'
         redirect_to user_path(user)
      else
         flash[:error] = "#{error_message(user.errors)}"
         redirect_to register_user_path
      end
   end

private

  def user_params
      params.require(:user).permit(:name, :email)
  end

end
