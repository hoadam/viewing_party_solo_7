class MovieService
  def movie_details(movie_id)
    json = get_url("/3/movie/#{movie_id}?append_to_response=reviews%2Ccredits")
    Movie.new(json)
  end

  def provider_details(movie_id, region = :US)
    json = get_url("/3/movie/#{movie_id}/watch/providers")
    Providers.new(json[:results][region])
  end

  def get_image_base_url
    json = get_url("/3/configuration")

    json[:images][:secure_base_url] + json[:images][:logo_sizes][0]
  end

  def conn
    Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] = Rails.application.credentials.tmdb[:key]
    end
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end


end
