class SessionsController < ApplicationController
  def new; end

  def create_param user
    params[:session][:remember_me] == Settings.session.checkbox_true ? remember(user) : forget(user)
  end

  def login_fail_action
    flash.now[:danger] = t "login_error_msg"
    render :new
  end

  def user_activate
    user = User.find_by email: params[:session][:email].downcase
    if user.activated?
      log_in user
      create_param user
      redirect_back_or user
    else
      flash[:warning] = t "not_yet_activate_warn"
      render :new
    end
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      user_activate
    else
      login_fail_action
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
