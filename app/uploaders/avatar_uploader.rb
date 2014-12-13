# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/avatars/#{file_digest[0..1]}"
  end

  def filename
    @filename ||= "#{file_digest[2..-1]}.#{file.extension}" if original_filename.present?
  end

  def default_url
    ActionController::Base.helpers.asset_path("defaults/avatar.png")
  end

  version :tiny do
    process :resize_to_fit => [60, 60]
  end

  version :small do
    process :resize_to_fit => [100, 100]
  end

  version :medium do
    process :resize_to_fit => [200, 200]
  end

  version :large do
    process :resize_to_fit => [500, 500]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def file_digest
    chunk = model.send(mounted_as)
    @digest ||= Digest::SHA1.hexdigest(chunk.read.to_s)
  end
end
