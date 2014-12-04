class Contest < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: 'author_id'
  has_and_belongs_to_many :problems
end

# == Schema Information
#
# Table name: contests
#
#  id                 :integer          not null, primary key
#  title              :string           not null
#  description_raw    :text             default("")
#  author_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  description_cooked :text             default("")
#  contest_status     :integer          default("0"), not null
#
