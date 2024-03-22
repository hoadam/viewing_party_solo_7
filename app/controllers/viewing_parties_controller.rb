class ViewingPartiesController < ApplicationController

  def new
    @movie = get_movie_details(params[:movie_id])

    @viewing_party = ViewingParty.new(duration: @movie[:runtime])
  end

  def create
    user = User.find(params[:user_id])

    viewing_party = ViewingParty.new(viewing_party_params)

    if viewing_party.save
      create_host(viewing_party, user)

      create_guests(viewing_party, guests_params)

      flash[:success] = "Successfully Created New Viewing Party"
      redirect_to user_path(user)
    else
      flash[:error] = "#{error_message(viewing_party.errors)}"
      redirect_to new_user_movie_viewing_party_path(user,params[:movie_id])
    end
  end

  def show
    get_providers(params[:movie_id])
    get_image
  end

  private
  def get_movie_details(movie_id)
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get("/3/movie/#{movie_id}?append_to_response=reviews%2Ccredits")
    data = JSON.parse(response.body, symbolize_names: true)

    data
  end

  def viewing_party_params
    params.require(:viewing_party).permit(:movie_id, :duration, :date, :start_time)
  end

  def create_host(viewing_party, user)
    UserParty.create!(viewing_party: viewing_party, user: user, host: true)
  end

  def create_guests(viewing_party, guests_params)
    guests_params.values.each do |email|
      if !email.blank?
        guest = User.find_by(email: email)
        if guest
          UserParty.create!(viewing_party: viewing_party, user: guest, host: false)
        end
      end
    end
  end

  def guests_params
    params.require(:viewing_party).permit(:guest1_email, :guest2_email, :guest3_email)
  end

  def get_providers(movie_id)
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get("/3/movie/#{movie_id}/watch/providers")
    data = JSON.parse(response.body, symbolize_names: true)

    @us_providers = data[:results][:US]
  end

  def get_image
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get("/3/configuration")
    data = JSON.parse(response.body, symbolize_names: true)

    @image_base_url = data[:images][:secure_base_url] + data[:images][:logo_sizes][0]
  end
end
