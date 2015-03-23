class Upload < ActiveRecord::Base
  attachment :upload, type: :image

  validates_presence_of :upload
end

# == Schema Information
#
# Table name: uploads
#
#  id                  :integer          not null, primary key
#  upload              :string
#  upload_filename     :string
#  upload_size         :integer
#  upload_content_type :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
