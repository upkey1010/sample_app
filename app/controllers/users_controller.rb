class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :define_user_var, except: %i(index new create)

  def define_user_var
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "cant_find_user"
    redirect_to action: :index
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_activation_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def index
    @users = User.sort_by_name.paginate(page: params[:page], per_page: Settings.paginate.user_perpage)
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "destroy_success"
    else
      flash[:danger] = t "destroy_success"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    @user  = User.find_by id: params[:id]
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = t "followers"
    @user  = User.find_by id: params[:id]
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    define_user_var
    redirect_to root_url unless current_user? @user
  end
end
