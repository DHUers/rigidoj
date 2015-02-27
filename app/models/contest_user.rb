class ContestUser < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user

  validates_associated :contest, :user
end

# == Schema Information
#
# Table name: contest_users
#
#  contest_id :integer          not null
#  user_id    :integer          not null
#
