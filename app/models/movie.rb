class Movie < ActiveRecord::Base
  def self.movie_ratings
  	Array['G','PG','PG-13','R']
  end
end
