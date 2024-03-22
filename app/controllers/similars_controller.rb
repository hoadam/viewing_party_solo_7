class SimilarsController < ApplicationController
  def show
    get_similar_movies(params[:movie_id])
    @image_base_url = get_image
  end

  private

  def get_similar_movies(movie_id)
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get("/3/movie/#{movie_id}/similar")
    data = JSON.parse(response.body, symbolize_names: true)

    @similar_movies = data[:results]
  end

  def get_image
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get("/3/configuration")
    data = JSON.parse(response.body, symbolize_names: true)

    data[:images][:secure_base_url] + data[:images][:logo_sizes][0]
  end
end
