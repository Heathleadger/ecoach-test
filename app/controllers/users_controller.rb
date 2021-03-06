class UsersController < ApplicationController
  
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]
  
  def index
   @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @user = User.new
  end
  
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to E-Coach Mr.(s) #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def edit

  end
  
  def update
    if @user.update(user_params)
       flash[:success] = "You profile was updated"
       redirect_to articles_path
    else
        render 'edit'
    end
  end

  def show
    if (!logged_in? || current_user != @user) and !current_user.admin?
      flash[:danger] = "You are not logged in with this user"
      redirect_to articles_path
    end
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "The user and all its articles has been deleted"
    redirect_to users_path
  end

  private
  
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def require_same_user
   if (!logged_in? || current_user != @user) and !current_user.admin? 
     flash[:danger] = "You are not the user of this account"
     redirect_to articles_path
   end
  end
  
  def require_admin
    if logged_in? && !current_user.admin?
      flash[:danger] = "You have to be an admin in order to perform this action"
      redirect_to root_path
    end
  end
end