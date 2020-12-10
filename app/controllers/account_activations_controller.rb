class AccountActivationsController < ApplicationController
  
  def edit 
    # <---------------------- Use of '!user.activated?' ----------------------->
    # (This will be a bit convoluted, anything within the border lines is the
    # detailed explanation of why Hartl placed !user.activated? as a condition.)
    #
    # Note the presence of '!user.activated?' prevents our code from activating 
    # users who have already been activated, which is important because we’ll be 
    # logging in users upon confirmation, and we don’t want to allow attackers 
    # who manage to obtain the activation link to log in as the user. 
    # <------------------------- END OF EXPLANATION --------------------------->
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
