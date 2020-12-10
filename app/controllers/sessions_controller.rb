class SessionsController < ApplicationController
  def new
    # debugger
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        # Log the user in and redirect to the user's show page
        
        # Use 'reset_session' to prevent session fixation attack (session is 
        # reset immediately before logging in).
        reset_session
        # Options to remember the user.
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)  
        log_in @user
        # Rails automatically converts this to the route for the user's profile 
        # page (seen in Section 7.4.1).
        redirect_to forwarding_url || @user
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Create an error message
      
      # Contents of 'flash.now' disappear as soon as there is an additional 
      # request.
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    # Log out completely if user is using multiple browser at the same time.
    log_out if logged_in?
    redirect_to root_url
  end
end
