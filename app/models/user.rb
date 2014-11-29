require 'pbkdf2'
require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :remember_token

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

  before_save :update_username_lower
  before_save :ensure_password_is_hashed

  after_initialize :set_default_active

  def self.username_length
    2..20
  end

  def self.max_password_length
    200
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.find_by_email(email)
    find_by(email: email.downcase)
  end

  def self.find_by_username(username)
    find_by(username_lower: username.downcase)
  end

  def self.find_by_username_or_email(username_or_email)
    if username_or_email.include?('@')
      find_by_email username_or_email
    else
      find_by_username username_or_email
    end
  end

  def self.username_available?(username)
    lower = username.downcase
    User.where(username_lower: lower).blank?
  end

  def update_username_lower
    self.username_lower = username.downcase
  end

  def downcase_email
    self.email.downcase! if self.email
  end

  def username_format_validator
    UsernameValidator.perform_validation(self, 'username')
  end

  def username_validator
    username_format_validator || begin
      existing = User.find_by(username_lower: username.downcase)
      if username_changed? && existing && existing.id != self.id
        errors.add(:username, I18n.t('user.username.unique'))
      end
    end
  end

  def password=(password)
    @raw_password = password unless password.blank?
  end

  def password_confirmation=(password_confirmation)
    @password_confirmation = password_confirmation unless password_confirmation.blank?
  end

  def password_validator
    if @raw_password != @password_confirmation
      errors.add(:password_confirmation, I18n.t('user.password_confirmation.not_match'))
    end
    PasswordValidator.new(attributes: :password).validate_each(self, :password, @raw_password)
  end

  def ensure_password_is_hashed
    self.salt = SecureRandom.hex(16)
    self.password_hash = hash_password(@raw_password, salt)
  end

  def hash_password(password, salt)
    raise "password is too long" if password.length > User.max_password_length
    Pbkdf2.hash_password(password, salt, Rails.configuration.pbkdf2_iterations, Rails.configuration.pbkdf2_algorithm)
  end

  def set_default_active
    self.active = true
  end

  def authenticate!(password)
    return false unless password_hash && salt
    self.password_hash == hash_password(password, salt)
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_hash, User.digest(self.remember_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_hash).is_password?(remember_token)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  username                :string(60)       not null
#  name                    :string(320)
#  email                   :string(300)      not null
#  password_hash           :string(64)
#  salt                    :string(32)
#  active                  :boolean          default("false"), not null
#  last_seen_at            :datetime
#  grade_and_class         :string
#  admin                   :boolean          default("false"), not null
#  solved_problem          :integer          default("0")
#  ip_address              :inet
#  registration_ip_address :inet
#  remember_hash           :string(60)
#  username_lower          :string(60)
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_last_seen_at    (last_seen_at)
#  index_users_on_username        (username) UNIQUE
#  index_users_on_username_lower  (username_lower) UNIQUE
#
