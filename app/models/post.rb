class Post < ActiveRecord::Base
  include Cookable

  belongs_to :author, class_name: :User, foreign_key: 'author_id', inverse_of: :post
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
#  author_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean          default("false"), not null
#
