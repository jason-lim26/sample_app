class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private
    
    # This was previously located at UsersController, it was then moved to
    # the current location so that MicropostsController is able to use this
    # method.
    #
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
