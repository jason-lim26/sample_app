module SessionsHelper
  
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    # Guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:session_token] = user.session_token
  end
  
  # Remember a user in a persistent session.
  def remember(user)
    # This will generate a remember token and saving its digest to the database.
    user.remember # The remember method is defined in model/user.rb
    # Create permanent cookies for the user id.
    cookies.permanent.encrypted[:user_id] = user.id
    # Then remembers the token.
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      # 'current_user' method hits the database the first time but returns the 
      # instance variable immediately on subsequent invocations
      user = User.find_by(id: user_id)
      @current_user ||= user if session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the given user is the current user.
  def current_user?(user)
    user && user == current_user
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget # The forget method is defined in model/user.rb
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Logs out the current user.
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
  
  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
