class SolutionSearchData < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :search_data
end

# == Schema Information
#
# Table name: solution_search_data
#
#  solution_id :integer          not null, primary key
#  search_data :tsvector
#  raw_data    :text
#
# Indexes
#
#  idx_search_solution  (search_data)
#
