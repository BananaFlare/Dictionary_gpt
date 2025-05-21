class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password]) && user.enabled?
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = 'Неверный логин/пароль или учётка заблокирована'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'Вы вышли'
  end
end
