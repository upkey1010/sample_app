class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t ".post_success"
      redirect_to root_url
    else
      @feed_items = Micropost.find_post_by_userid(current_user).paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".post_del_success"
    else
      flash[:danger] = t ".post_del_fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "log_in_msg"
    redirect_to login_url
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url unless @micropost
  end
end
