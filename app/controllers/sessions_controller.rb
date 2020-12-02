class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page
      
      # Use 'reset_session' to prevent session fixation attack (session is 
      # reset immediately before logging in).
      reset_session
      log_in user
      # Rais automatically converts this to the route for the user's profile 
      # page (seen in Section 7.4.1).
      redirect_to user
    else
      # Create an error message
      
      # Contents of 'flash.now' disappear as soon as there is an additional 
      # request.
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
