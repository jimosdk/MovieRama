class SessionsController < ApplicationController
    before_action :require_unsigned_user, only: [:new,:create]
    before_action :require_current_user , only: [:destroy]

    def new 
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:session][:username],
                                         params[:session][:password])
        if @user 
            log_in!
            redirect_to movies_url(filter: filter_params)                       #Passing filter_params in order to preserve active filters during login
        else  
            flash.now[:errors] = ["Invalid Credentials"]
            render :new
        end

    end

    def destroy 
        log_out!
        redirect_to new_session_url
    end

    private 

    def session_params
        params.require(:session).permit(:username,:password)
    end
end