class AdminController < ApplicationController
  before_action :require_admin

  def index
    # Admin dashboard logic here
  end

  def users
    @q = params[:q]
    if @q.present?
      LoggerService.info("Admin search users with query: #{@q}") if LoggerService.enabled?
      @users = User.where("LOWER(email) LIKE LOWER(?)", "%#{@q}%").order(:email)
    else
      LoggerService.info("Admin viewed all users") if LoggerService.enabled?
      @users = User.order(:email)
    end
  end

  def toggle_block
    user = User.find(params[:id])
    if user.admin?
      LoggerService.info("Admin attempted to block admin user: #{user.email}") if LoggerService.enabled?
      flash[:alert] = "Нельзя заблокировать администратора"
    else
      user.update(enabled: !user.enabled)
      LoggerService.info("Admin toggled block status for user #{user.email} to #{user.enabled}") if LoggerService.enabled?
      flash[:notice] = user.enabled ? "Пользователь разблокирован" : "Пользователь заблокирован"

      # Invalidate session if user is currently logged in and blocked
      if !user.enabled
        # Assuming sessions are stored in DB or cache, here we just log out if current_user is blocked
        # This requires a mechanism to track sessions per user, which may not be implemented
        # As a workaround, we can add a before_action in ApplicationController to check user enabled status
      end
    end
    redirect_to admin_users_path
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Доступ запрещён'
    end
  end
end
