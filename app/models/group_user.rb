class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates_associated :user, :group

end

# == Schema Information
#
# Table name: group_users
#
#  group_id :integer          not null
#  user_id  :integer          not null
#
