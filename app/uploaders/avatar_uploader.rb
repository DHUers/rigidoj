# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  after :cache, :update_digest

  storage :file

  def store_dir
    "uploads/avatars/#{uuid[0..1]}"
  end

  def filename
    @filename = "#{uuid}.#{file.extension}" if original_filename.present?
  end

  def default_url
    ActionController::Base.helpers.asset_path("defaults/avatar.png")
  end

  version :tiny do
    process resize_to_fit: [60, 60]
  end

  version :small do
    process resize_to_fit: [100, 100]
  end

  version :medium do
    process resize_to_fit: [200, 200]
  end

  version :large do
    process resize_to_fit: [500, 500]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  protected

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  private

  def update_digest(file)
    var = :"#{mounted_as}_digest="
    model.send(var, uuid)
  end
end
