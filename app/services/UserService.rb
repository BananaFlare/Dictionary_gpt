# frozen_string_literal: true

module UserService
  def self.user_id_or_temp_user_creation(session)
    if session[:user_id].nil?
      # password = SecureRandom.alphanumeric(11).chars.shuffle.join
      password = "qwerty"
      tmp_user = User.new(
        email: "TMP#{Time.now.to_i}@temp.com",
        password: password,  # передаём пароль через виртуальный атрибут
        temp: true
      )
      tmp_user.save
      user_id = tmp_user.id
    else
      user_id = session[:user_id]
    end
    session[:user_id] = user_id
    return user_id
  end
  def self.dictionaries_transfer_from_temp_to_permanent (user_id,tmp_user_id)
    dicts = Dictionary.where(user_id: tmp_user_id)
    unless dicts.nil?
      dicts.each do |dict|
        dict.update(user_id: user_id)
      end
    end
    p Dictionary.where(user_id: tmp_user_id)
  end
end
