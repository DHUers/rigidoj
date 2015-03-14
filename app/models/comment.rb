class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
end

# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  post_id        :integer          not null
#  user_id        :integer          not null
#  comment_number :integer          not null
#  raw            :text             not null
#  baked          :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
