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

  def check_user_enabled
    if current_user && !current_user.enabled
      reset_session
      redirect_to login_path, alert: 'Ваша учётная запись заблокирована. Обратитесь к администратору.'
    end
  end

  before_action :check_user_enabled

  def log_info(message)
    LoggerService.info(message)
  end
end
 
