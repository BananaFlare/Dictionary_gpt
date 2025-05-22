class SessionsController < ApplicationController
  def authorisation; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user.nil?
      LoggerService.info("Попытка входа с несуществующим email: #{params[:email]}") if LoggerService.enabled?
      flash.now[:alert] = 'Пользователь с таким email не найден'
      render :authorisation and return
    end

    if user&.authenticate(params[:password])
      if user.enabled?
        session[:user_id] = user.id
        LoggerService.info("Пользователь #{user.email} успешно вошел в систему") if LoggerService.enabled?
        if user.admin?
          redirect_to admin_dashboard_path
        else
          redirect_to profile_path
        end
      else
        LoggerService.info("Попытка входа заблокированного пользователя #{user.email}") if LoggerService.enabled?
        flash.now[:alert] = 'Ваша учётная запись заблокирована. Обратитесь к администратору.'
        render :authorisation and return
      end
    else
      LoggerService.info("Неудачная попытка входа для пользователя #{params[:email]}") if LoggerService.enabled?
      flash.now[:alert] = 'Неверный логин/пароль'
      render :authorisation
    end
  end

  def destroy
    LoggerService.info("Пользователь вышел из системы") if LoggerService.enabled?
    session.delete(:user_id)
    redirect_to root_path, notice: 'Вы вышли'
  end
end
