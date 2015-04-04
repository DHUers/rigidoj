require 'pretty_text'

class Post < ActiveRecord::Base
  has_one :post_search_data, dependent: :destroy
  has_many :comments, -> { order('comment_number ASC') }, dependent: :destroy
  has_many :notifications
  belongs_to :contest
  belongs_to :problem
  belongs_to :user

  scope :published, -> { where(published: true) }
  scope :pinned, -> { where(pinned: true) }

  validates :title, length: { in: 2..60 }, presence: true

  def first_comment
    comments.first
  end
end

# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  published     :boolean          default(FALSE), not null
#  pinned        :boolean          default(FALSE)
#  comment_count :integer          default(0), not null
#  contest_id    :integer
#  user_id       :integer
#
