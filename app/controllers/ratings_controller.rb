class RatingsController < ApplicationController
    before_action :require_current_user
    before_action :require_user_that_created_this_rating,except: [:create]
    before_action :require_not_duplicate_rating_value, only: [:update]
    before_action :require_not_author_of_post,only: [:create]

    def create 
        @rating = Rating.new(post_id: params[:movie_id],value: params[:rating][:value])
        @rating.user_id = current_user.id 
        
        if @rating.save 
            redirect_to movies_url(filter: filter_params)
        else  
            flash.now[:errors] = @rating.errors.full_messages
            redirect_to movies_url(filter: filter_params)
        end
    end

    def update 
        @rating ||= Rating.find_by(id: params[:id])
        if @rating.update(value: params[:rating][:value])
            redirect_to movies_url(filter: filter_params)
        else  
            flash.now[:errors] = @rating.errors.full_messages
            redirect_to movies_url(filter: filter_params)
        end
    end 

    def destroy 
        @rating ||= Rating.find_by(id: params[:id])
        @rating.destroy 
        redirect_to movies_url(filter: filter_params)
    end

    private 

    def rating_params
        params.require(:rating).permit(:post_id,:value)
    end

    def require_not_duplicate_rating_value
        #Check to see if current user has already rated this post 
        #with the same value ,if at all
        @rating ||= Rating.find_by(id: params[:id])
        redirect_to movies_url(filter: filter_params) if @rating && @rating.value == params[:rating][:value]
    end

    def require_user_that_created_this_rating
        #check to see if the requesting user is the one that rated 
        #the post (meaning he created the rating entry thats going to be 
        #updated/destroyed)
        @rating ||= Rating.find_by(id: params[:id])
        redirect_to movies_url(filter: filter_params) unless current_user && current_user.id ==  @rating.user_id
    end

    def require_not_author_of_post 
        #check if rating user is the author of the rated post
        redirect_to movies_url(filter: filter_params) if current_user.own_post(params[:movie_id])
    end
end