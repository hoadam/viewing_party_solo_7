class UsersController < ApplicationController
   def new
      @user = User.new
   end

   def show
      @user = User.find(params[:id])
      @image_base_url = get_image_base_url
      @movie_info = {}
      @user.viewing_parties.each do |party|
         if party.movie_id != nil

            movie = get_movie_details(party.movie_id)

            @movie_info[party.id] = {
               title: movie[:original_title],
               poster: @image_base_url + movie[:poster_path]
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

  def get_image_base_url
   conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
     faraday.headers['Authorization'] =
       'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
   end

   response = conn.get("/3/configuration")
   data = JSON.parse(response.body, symbolize_names: true)

   data[:images][:secure_base_url] + data[:images][:logo_sizes][0]
 end

 def get_movie_details(movie_id)
   conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
     faraday.headers['Authorization'] =
       'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
   end
   response = conn.get("/3/movie/#{movie_id}?append_to_response=reviews%2Ccredits")

   JSON.parse(response.body, symbolize_names: true)
 end

end
