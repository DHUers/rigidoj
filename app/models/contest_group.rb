class ContestGroup < ActiveRecord::Base
  belongs_to :contest
  belongs_to :group
end

# == Schema Information
#
# Table name: contest_groups
#
#  id         :integer          not null, primary key
#  contest_id :integer          not null
#  group_id   :integer          not null
#
# Indexes
#
#  index_contest_groups_on_contest_id_and_group_id  (contest_id,group_id) UNIQUE
#
