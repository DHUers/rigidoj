class Contest < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: 'author_id'
end

# == Schema Information
#
# Table name: contests
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :string           default("")
#  published   :boolean          default("false")
#  author_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
