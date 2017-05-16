class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def generate_password
    pwd = Devise.friendly_token.first(20)
    self.password = pwd
    self.password_confirmation = pwd
  end
end
