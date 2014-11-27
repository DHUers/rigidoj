class Contest < ActiveRecord::Base
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
