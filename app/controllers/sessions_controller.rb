class SessionsController < ApplicationController

  before_action :require_no_user!, only: [:new, :create]

  def destroy
    session[:session_token] = nil
    current_user.reset_session_token! if current_user
    redirect_to new_session_url
  end

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if user.nil?
      flash.now[:errors] = ["Invalid entry"]
      render :new
    else

      login_user!(user)
      redirect_to cats_url
    end
  end


end
