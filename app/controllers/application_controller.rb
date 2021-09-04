class ApplicationController < ActionController::Base
    helper_method :current_user,:current_user_preload,:filter_params

    def current_user 
        #Finds the signed up user making the requests,if any
        return nil unless session[:session_token]
        User.find_by(session_token: session[:session_token])
    end

    def current_user_preload
        #Finds the signed up user making the requests,if any
        #Also preloads ratings and posts to deal with N+1 queries
        return nil unless session[:session_token]
        User.includes(:ratings,:posts).
        find_by(session_token: session[:session_token])
    end

    def log_in!
        session[:session_token] = @user.reset_session_token!
    end

    def log_out!
        current_user.reset_session_token!
        session[:session_token] = nil 
    end

    def require_current_user
        #Used in callbacks,prevents logged in users from accessing certain actions
        redirect_to new_session_url unless current_user
    end

    def require_unsigned_user
        #Used in callbacks,prevents logged in users from accessing certain actions
        redirect_to movies_url if current_user
    end

    def filter_params
        #Used in sessions controller and sessions/new in order to preserve filters during log in 
        params.require(:filter).permit(:poster,:sorting_field,:sorting_order) unless params[:filter].blank?
    end
end
