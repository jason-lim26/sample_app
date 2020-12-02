class UsersController < ApplicationController
  # Adding a line of 'debugger' in any method to track any application errors.
  def new
    @user = User.new
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
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
