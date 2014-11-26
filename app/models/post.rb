class Post < ActiveRecord::Base
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
