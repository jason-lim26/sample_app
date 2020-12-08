class UsersController < ApplicationController
  # Invoke the private logged_in_user method prior to editing.
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # Invoke the private correct_user method prior to editing.
  before_action :correct_user, only: [:edit, :update]
  # Enforce access control, this time to restrict accessto the 'destroy' action
  # to admins.
  before_action :admin_user,  only: :destroy
  
  # Adding a line of 'debugger' in any method to track any application errors.
  def new
    @user = User.new
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)   # Not the final implementation!
    if @user.save
      reset_session
      # Allow users to automatically log themselves in after signing up.
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # Can also be written as:
      # redirect_to user_url(@user)
    else 
      render 'new'
    end
  end
  
  def edit
    # Note that the correct_user before filter defines the @user variable, so we
    # can eliminate the @user assignments in the 'edit' and 'update' actions.
    
    # ELIMINATED: @user = User.find(params[:id])
  end
  
  def update
    # ELIMINATED: @user = User.find(params[:id])
    if @user.update(user_params)
      # Handles a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # The errors shown will be similar to signup
      render 'edit'
    end 
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation)
    end
    
    # Before filters
    
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:danger] = "Wrong user."
        redirect_to(root_url)
      end
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
