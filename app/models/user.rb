require_dependency 'pbkdf2'

class User < ActiveRecord::Base
  has_many :solutions
  has_many :problems, foreign_key: 'author_id'
  has_many :posts, foreign_key: 'author_id'
  has_many :contests, foreign_key: 'author_id'

  before_validation :downcase_email

  validates_presence_of :username
  validate :username_validator
  validates :email, presence: true, uniqueness: true
  validates :email, email: true, if: :email_changed?
  validate :password_validator

  before_save :ensure_password_is_hashed

  def self.username_length
    2..20
  end

  def self.max_password_length
    200
  end

  def downcase_email
    self.email.downcase! if self.email
  end

  def username_format_validator
    UsernameValidator.perform_validation(self, 'username')
  end

  def username_validator
    username_format_validator || begin
      existing = User.find_by(username: username)
      if username_changed? && existing && existing.id != self.id
        errors.add(:username, I18n.t('user.username.unique'))
      end
    end
  end

  def password=(password)
    @raw_password = password unless password.blank?
  end

  def password_validator
    PasswordValidator.new(attributes: :password).validate_each(self, :password, @raw_password)
  end

  def ensure_password_is_hashed
    self.salt = SecureRandom.hex(16)
    self.password_hash = hash_password(@raw_password, salt)
  end

  def hash_password(password, salt)
    raise "password is too long" if password.size > User.max_password_length
    Pbkdf2.hash_password(password, salt, Rails.configuration.pbkdf2_iterations, Rails.configuration.pbkdf2_algorithm)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  username                :string           not null
#  name                    :string
#  email                   :string           not null
#  password_hash           :string
#  salt                    :string
#  active                  :boolean          default("false"), not null
#  last_seen_at            :datetime
#  grade_and_class         :string
#  admin                   :boolean          default("false"), not null
#  solved_problem          :integer          default("0")
#  ip_address              :inet
#  registration_ip_address :inet
#
