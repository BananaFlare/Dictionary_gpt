require_relative '../services/UserService'

class SessionsController < ApplicationController
  def authorisation; end

  # обработка случая когда пользователь пытаестся зайти под несуществующим аккаунтом
  # по идее должна быть не здесь а в user
  # и наверное должно быть сделано через validates
  def create
    user = User.find_by(email: params[:email].downcase)

    if user.nil?
      LoggerService.info("Попытка входа с несуществующим email: #{params[:email]}") if LoggerService.enabled?
      flash.now[:alert] = 'Пользователь с таким email не найден'
      render :authorisation and return
    end

    if user&.authenticate(params[:password])
      unless session[:user_id].nil?
        tmp_user_id = session[:user_id]
        tmp_user = User.find(tmp_user_id)
        if tmp_user.temp
          UserService.dictionaries_transfer_from_temp_to_permanent(user.id, tmp_user_id)
        end
      end

      session[:user_id] = user.id
      LoggerService.info("Пользователь #{user.email} успешно вошел в систему") if LoggerService.enabled?

      redirect_to profile_path
    else
      LoggerService.info("Неудачная попытка входа для пользователя #{params[:email]}") if LoggerService.enabled?
      flash.now[:alert] = 'Неверный пароль'
      render :authorisation
    end
  end

  def destroy
    user = User.find(session[:user_id])
    unless user.temp
      session.delete(:user_id)
      UserService.user_id_or_temp_user_creation(session)
      p session
    end
    LoggerService.info("Пользователь вышел из системы") if LoggerService.enabled?
    redirect_to root_path, notice: 'Вы вышли'
  end
end
