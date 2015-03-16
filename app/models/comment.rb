class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  before_save :cook
  after_save :update_comment_count

  validates_presence_of :raw

  def cook
    self.baked = PrettyText::cook(self.raw)
  end

  def update_comment_count
    post.increment!(:comment_count)
  end

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
