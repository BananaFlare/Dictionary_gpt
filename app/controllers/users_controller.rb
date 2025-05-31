class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path, notice: 'Регистрация прошла успешно'
    else
      flash.now[:alert] = 'Ошибка регистрации. Пожалуйста, проверьте введённые данные.'
      render :new
    end
  end

  def show
    if session[:user_id].present?
      @user = User.find(session[:user_id])
      p @user.id
      @dict = Dictionary.where(user_id: @user.id).to_a
      p @dict
    else
      redirect_to login_path, alert: 'Пожалуйста, войдите в систему.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
