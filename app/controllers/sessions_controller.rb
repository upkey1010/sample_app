class SessionsController < ApplicationController
  def new; end

  def create_param user
    params[:session][:remember_me] == Settings.session.checkbox_true ? remember(user) : forget(user)
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      create_param user
      redirect_to user
    else
      flash.now[:danger] = t "login_error_msg"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
