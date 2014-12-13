require 'pbkdf2'
require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessor :remember_token

  has_one :user_stat, dependent: :destroy
  has_many :solutions
  has_many :posts
  has_many :contests
  has_many :problems

  mount_uploader :avatar, AvatarUploader

  before_validation :downcase_email

  validates_presence_of :username
  validate :username_validator
  validates :email, presence: true, uniqueness: true
  validates :email, email: true, if: :email_changed?
  validate :password_validator, on: [:create]

  before_create :build_user_stat

  before_save :update_username_lower
  before_save :ensure_password_is_hashed
  before_save :update_avatar_digest

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

  def password
    @raw_password
  end

  def password_validator
    PasswordValidator.new(attributes: :password).validate_each(self, :password, @raw_password)
  end

  def ensure_password_is_hashed
    if @raw_password
      self.salt = SecureRandom.hex(16)
      self.password_hash = hash_password(@raw_password, salt)
    end
  end

  def hash_password(password, salt)
    raise 'password is too long' if password.length > User.max_password_length
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

  def forget
    update_column(:remember_hash, nil)
  end

  def change_username(new_username)
    self.username = new_username
    save
  end

  def update_last_seen!(now=Time.zone.now)
    update_column(:last_seen_at, now)
  end

  def username_format_validator
    UsernameValidator.perform_validation(self, 'username')
  end

  def to_param
    username_lower
  end

  def staff?
    moderator? || admin?
    end

  private

  def update_avatar_digest
    if avatar.present? && avatar_changed?
      self.avatar_digest  = avatar.hash
    end
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
#  admin                   :boolean          default("false"), not null
#  ip_address              :inet
#  registration_ip_address :inet
#  remember_hash           :string(60)
#  username_lower          :string(60)       not null
#  suspended               :boolean          default("false"), not null
#  suspended_at            :datetime
#  suspended_till          :datetime
#  last_emailed_at         :datetime
#  moderator               :boolean          default("false")
#  blocked                 :boolean          default("false")
#  email_notification      :boolean          default("true")
#  email_digest            :boolean          default("false")
#  email_contest_result    :boolean          default("true")
#  email_solution_result   :boolean          default("false")
#  avatar                  :string
#  avatar_digest           :string
#  show_email              :boolean          default("true"), not null
#  website                 :string(255)
#
# Indexes
#
#  index_users_on_avatar_digest   (avatar_digest) UNIQUE
#  index_users_on_email           (email) UNIQUE
#  index_users_on_last_seen_at    (last_seen_at)
#  index_users_on_username        (username) UNIQUE
#  index_users_on_username_lower  (username_lower) UNIQUE
#
