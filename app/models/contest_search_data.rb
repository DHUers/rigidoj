class ContestSearchData < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :search_data
end

# == Schema Information
#
# Table name: contest_search_data
#
#  contest_id  :integer          not null, primary key
#  search_data :tsvector
#  raw_data    :text
#
# Indexes
#
#  idx_search_contest  (search_data)
#
