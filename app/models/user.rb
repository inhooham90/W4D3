# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  password_digest :string           not null
#  session_token   :string
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'action_view'

class User < ApplicationRecord
  include ActionView::Helpers::DateHelper

  attr_reader :password

  validates :session_token, uniqueness: true

  after_initialize :ensure_session_token

  has_many :cats,
    foreign_key: :user_id,
    class_name: 'Cat'

  def reset_session_token!
   self.session_token = self.class.generate_session_token
   self.save!
   self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return user if user && BCrypt::Password.new(user.password_digest).is_password?(password)
    nil
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

end
