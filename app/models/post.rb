class Post < ActiveRecord::Base
  scope :published, -> { where(published: true) }

  self.per_page = 30
end

# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  raw        :string           not null
#  baked      :string           not null
#  author     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
