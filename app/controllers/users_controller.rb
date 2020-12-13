class UsersController < ApplicationController
  # Invoke the private logged_in_user method prior to editing.
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
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
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)   # Not the final implementation!
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation)
    end
    
    # Before filters.
    
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
