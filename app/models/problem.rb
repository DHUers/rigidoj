class Problem < ActiveRecord::Base
  include Cookable

  scope :published, -> { where(published: true) }

  self.per_page = 30
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
#  memory_limit :integer          default("65535"), not null
#  time_limit   :integer          default("1000"), not null
#  source       :string           default("")
#  author_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published    :boolean
#
