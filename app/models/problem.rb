class Problem < ActiveRecord::Base
  include Cookable
  belongs_to :author, class_name: :User, foreign_key: 'author_id'
  has_many :solutions
  has_and_belongs_to_many :contests
  scope :published, -> { where(published: true) }

end

# == Schema Information
#
# Table name: problems
#
#  id           :integer          not null, primary key
#  title        :string           default("")
#  excerpt      :string           default("")
#  raw          :text             default("")
#  baked        :text             default("")
#  source       :string           default("")
#  author_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published    :boolean          default("false")
#  memory_limit :json             default("{\"default\":65535}")
#  time_limit   :json             default("{\"default\":1000}")
#
