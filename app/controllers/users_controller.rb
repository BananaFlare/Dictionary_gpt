class UsersController < ApplicationController
  def new
    @user = User.new
  end
  #возможно нужно сразу входить в сесию, т.е создавать ее прям тут
  def create
    p user_params
    @user = User.new(user_params)
    if @user.save
      if User.find(session[:user_id])&.temp
        unless Dictionary.find_by(user_id: session[:user_id]).nil?
          UserService.dictionaries_transfer_from_temp_to_permanent(@user.id,session[:user_id])
        end
      else

      end
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
    else
      redirect_to login_path, alert: 'Пожалуйста, войдите в систему.'
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
