class UserProfile < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
end

# == Schema Information
#
# Table name: user_profiles
#
#  user_id            :integer          not null, primary key
#  grade_and_class    :string
#  school             :string
#  website            :string(255)
#  bio_raw            :text
#  bio_cooked         :text
#  profile_background :string
#  card_background    :string
#
