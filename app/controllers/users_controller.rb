class UsersController < ApplicationController

  # def index
  #   @users = User.all
  #   render :index
  # end

  # def show
  #   @user = User.find(params[:id])
  #   render :show
  # end

  before_action :require_no_user!

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:session_token] = @user.session_token
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end



  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
