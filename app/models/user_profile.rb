class UserProfile < ActiveRecord::Base
end

# == Schema Information
#
# Table name: user_profiles
#
#  users_id           :integer          not null, primary key
#  grade_and_class    :string
#  school             :string
#  website            :string(255)
#  bio_raw            :text
#  bio_cooked         :text
#  profile_background :string
#  card_background    :string
#
