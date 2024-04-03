class MoviesController < ApplicationController
  def index
    if params[:q] == 'top_rated'
      search_top_rated_movies
    else
      search
    end
  end

  def search
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get('/3/search/movie', { query: params[:q] })

    data = JSON.parse(response.body, symbolize_names: true)

    @search_movies = data[:results].first(20)
  end

  def search_top_rated_movies
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get('/3/movie/top_rated')

    data = JSON.parse(response.body, symbolize_names: true)

    @top_rated_movies = data[:results].first(20)
  end

  def show
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmNkNTNjOTBjMjE3NmVmYTg3MDY3NGM2N2NjNjAxNSIsInN1YiI6IjY1ZjkwY2FkMzg0NjlhMDE0OTdkNTI0MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P64TF2h_KOK6_bJc8o777vt23F71GxnoiAPCosoTj34'
    end

    response = conn.get("/3/movie/#{params[:id]}?append_to_response=reviews%2Ccredits")
    data = JSON.parse(response.body, symbolize_names: true)

    @movie = data
  end
end
