class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  has_many :solutions
  has_many :problems, foreign_key: 'author_id'
  has_many :posts, foreign_key: 'author_id'
  has_many :contests, foreign_key: 'author_id'
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default("0"), not null
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#
