class Post < ActiveRecord::Base
  include Cookable

  belongs_to :user
  scope :published, -> { where(published: true) }

  validates :title, length: { in: 2..60 }, presence: true
  validates :author, presence: true
end

# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  raw        :string           not null
#  baked      :text             default(""), not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean          default("false"), not null
#
