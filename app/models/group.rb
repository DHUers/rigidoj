class Group < ActiveRecord::Base
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :contest_groups
  has_many :contest, through: :contest_groups

  accepts_nested_attributes_for :users

  scope :visible, -> { where(visible: true) }

  validates_presence_of :name
  before_save :downcase_groupname

  def downcase_groupname
    self.group_name = group_name.downcase
  end

  def usernames
    users.pluck(:username).join(',')
  end

  def add(user)
    self.users.push(user)
  end

  def remove(user)
    self.groups_users.where(user: user).each(&:destroy)
  end

  protected

  def name_format_validator
    UsernameValidator.perform_validation(self, 'group_name')
  end

end

# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  visible    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_name :string
#
# Indexes
#
#  index_groups_on_name  (name) UNIQUE
#
