class PasswordResetsController < ApplicationController
  before_action :def_user_var,   only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_mail_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "cant_find_email"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("cant_blank"))
      render "edit"
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t "pw_reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def def_user_var
    @user = User.find_by(email: params[:email])
    return if @user
    flash[:danger] = t "cant_find_user"
    redirect_to root_url
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "expired_token"
    redirect_to new_password_reset_url
  end
end
