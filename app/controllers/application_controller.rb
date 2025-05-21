class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
    helper_method :current_user
 allow_browser versions: :modern
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    redirect_to login_path, alert: 'Сначала войдите' unless current_user
  end
end
 
