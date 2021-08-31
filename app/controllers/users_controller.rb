class UsersController < ApplicationController
    before_action :require_unsigned_user, only: [:new,:create]

    def new 
        @user = User.new 
        render :new 
    end

    def create 
        @user = User.new(user_params)
        if @user.save 
            log_in!
            redirect_to movies_url 
        else  
            flash.now[:errors] = @user.errors.full_messages
            render :new 
        end
    end

    private 

    def user_params
        params.require(:user).permit(:username,:password)
    end
end