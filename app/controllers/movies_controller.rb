class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session.update(params)
    if (params[:ratings] == nil or params[:method] == nil) then
      flash.keep
      redirect_to movies_path({:method => session[:method], :ratings => session[:ratings]})
    end
    if (session[:method] == "by_title") then
      @title_header = 'hilite'
      @movies = Movie.where(rating: session[:ratings].keys).order(:title)
    elsif (session[:method] == "by_date") then
      @release_date_header ='hilite'
      @movies = Movie.where(rating: session[:ratings].keys).order(:release_date)
    else
      if (session[:ratings]) then
        @movies = Movie.where(rating: session[:ratings].keys)
      else
        @movies = Movie.all
      end
    end
    @selected_ratings = session[:ratings].keys
    @all_ratings = Movie.movie_ratings()
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
