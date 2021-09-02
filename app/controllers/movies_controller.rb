class MoviesController < ApplicationController 
    helper_method :movies_are_sorted?,:movies_are_filtered_by_poster?
    
    before_action :require_current_user, only: [:new,:create]

    def index 
        #Filter state is preserved when configuring/updating filters,
        #during log in.
        #This is achieved by passing a filters param values until a filter is 
        #disabled.Filter params are : param[:filter][:poster],
        #param[:filter][:sorting_field],param[:filter][:sorting_order]

        if movies_are_filtered_by_poster?
            #Filter movie posts by poster,if filter params are valid
            @user = User.find_by(id: params[:filter][:poster])
            @movies = @user.posts
        else
            #otherwise fetch all movies and preload corresponding posters 
            @movies = Movie.includes(:poster).all
        end

        if movies_are_sorted? && %w(asc desc).include?(params[:filter][:sorting_order])
            #Sort movie posts by poster,if filter params are valid
            case params[:filter][:sorting_field]
            when 'created_at'
                @movies = @movies.
                order(create_at: params[:filter][:sorting_order]) 
            when 'likes'
                @movies = @movies.
                select("movies.*").
                joins(:ratings).
                where(ratings:{value: 'like'}).
                group(:id).
                order("COUNT(movies.id) #{params[:filter][:sorting_order].upcase}")
                #order(ratings: params[:filter][:sorting_order])
            when 'hates'
                @movies= @movies.
                select("movies.*").
                joins(:ratings).
                where(ratings:{value: 'hate'}).
                group(:id).
                order("COUNT(movies.id) #{params[:filter][:sorting_order].upcase}")
                #order(ratings: params[:filter][:sorting_order])
            end
        end
        render :index
    end

    def new 
        @movie = Movie.new 
    end

    def create 
        @movie = Movie.new(movie_params)
        @movie.poster_id = current_user.id 
        if @movie.save 
            redirect_to movies_url(filter: filter_params)
        else
            flash.now[:errors] = @movie.errors.full_messages
            render :new 
        end
    end

    protected

    def movie_params
        params.require(:movie).permit(:title,:description)
    end

    def movies_are_sorted?
        params[:filter] && !params[:filter][:sorting_field].blank?
    end

    def movies_are_filtered_by_poster?
        params[:filter] && !params[:filter][:poster].blank?
    end
end