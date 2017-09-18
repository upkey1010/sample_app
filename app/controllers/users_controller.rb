class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user.blank?
      flash[:danger] = t(".error_message")
      redirect_to action: "index"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t("welcome")
      redirect_to @user
    else
      render "new"
    end
  end

  def index
    @users = User.sort_by_name
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
