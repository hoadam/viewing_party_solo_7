class ViewingPartiesController < ApplicationController
  def new
    @movie = get_movie_details(params[:movie_id])

    @viewing_party = ViewingParty.new(duration: @movie.runtime)
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

    movie_service = MovieService.new
    @image_base_url = movie_service.get_image_base_url

  end

  private
  def get_movie_details(movie_id)
    movie_service = MovieService.new
    movie_service.movie_details(movie_id)
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
    movie_service = MovieService.new
    @us_providers = movie_service.provider_details(movie_id)
  end


end
