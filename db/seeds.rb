# Create admin user with login 'admin' and password 'admin'
User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'admin'
  user.password_confirmation = 'admin'
  user.admin = true
end
