class Movie
  attr_reader :runtime,
             :title,
             :poster

  def initialize(attributes)
    @runtime = attributes[:runtime]
    @title = attributes[:original_title]
    @poster = attributes[:poster_path]
  end
end
