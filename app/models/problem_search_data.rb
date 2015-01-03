class ProblemSearchData < ActiveRecord::Base
  belongs_to :problem
end

# == Schema Information
#
# Table name: problem_search_data
#
#  problem_id  :integer          not null, primary key
#  search_data :tsvector
#  raw_data    :text
#
# Indexes
#
#  idx_search_data  (search_data)
#
