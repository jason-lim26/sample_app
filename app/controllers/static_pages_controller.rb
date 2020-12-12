class StaticPagesController < ApplicationController
  def home
    # current_user exists only if the user is logged in, so the @micropost 
    # variable should only be defined in this case.
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about 
  end
  
  def contact
  end
end
