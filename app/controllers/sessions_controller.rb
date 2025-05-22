class SessionsController < ApplicationController
  def authorisation; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user.nil?
      LoggerService.info("Попытка входа с несуществующим email: #{params[:email]}") if LoggerService.enabled?
      flash.now[:alert] = 'Пользователь с таким email не найден'
      render :authorisation and return
    end

    if user&.authenticate(params[:password]) && user.enabled?
      session[:user_id] = user.id
      LoggerService.info("Пользователь #{user.email} успешно вошел в систему") if LoggerService.enabled?
      redirect_to profile_path
    else
      LoggerService.info("Неудачная попытка входа для пользователя #{params[:email]}") if LoggerService.enabled?
      flash.now[:alert] = 'Неверный логин/пароль или учётная запись заблокирована'
      render :authorisation
    end
  end

  def destroy
    LoggerService.info("Пользователь вышел из системы") if LoggerService.enabled?
    session.delete(:user_id)
    redirect_to root_path, notice: 'Вы вышли'
  end
end
