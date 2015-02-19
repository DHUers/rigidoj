class Group < ActiveRecord::Base
  has_many :groups_users, dependent: :destroy
  has_many :users, through: :groups_users
end

# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  visible    :boolean          default("true"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
