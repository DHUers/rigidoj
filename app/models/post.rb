require 'pretty_text'

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  scope :published, -> { where(published: true) }

  validates :title, length: { in: 2..60 }, presence: true
  validates :author, presence: true

  before_save :cook

  def cook
    self.baked = PrettyText::cook(self.raw)
  end
end

# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  published  :boolean          default(FALSE), not null
#
