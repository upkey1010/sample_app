class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if logged_in?
    @feed_items = Micropost.find_post_by_userid(current_user.id).paginate(page: params[:page]) if logged_in?
  end

  def help; end

  def about; end

  def contact; end
end
