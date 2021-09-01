class MoviesController < ApplicationController 
    helper_method :movies_are_sorted?,:movies_are_filtered_by_poster?

    def index 
        #Filter state is preserved when configuring/updating filters,
        #during log in and when creating/editing/deleting a post.
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

        if movies_are_sorted?
            #Sort movie posts by poster,if filter params are valid
            @movies = @movies.
            order(params[:filter][:sorting_field] => params[:filter][:sorting_order]) 
        end
    end

    protected

    def movies_are_sorted?
        params[:filter] && !params[:filter][:sorting_field].blank?
    end

    def movies_are_filtered_by_poster?
        params[:filter] && !params[:filter][:poster].blank?
    end
end