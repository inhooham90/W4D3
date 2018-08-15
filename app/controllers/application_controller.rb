class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  helper_method :current_user


  private

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def require_no_user!
   redirect_to cats_url if current_user
  end

  def require_cat_owner!
   redirect_to cats_url unless current_user.cats.pluck(:id).include?(Cat.find_by(id: params[:id]))
  end

  def logout_user!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

end
