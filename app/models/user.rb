class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  def admin?
    self.admin
  end

  scope :admins, -> { where(admin: true) }
end
