# encoding: utf-8

class PlainTextUploader < CarrierWave::Uploader::Base
  include UploaderBaseHelper

  storage :file

  def extension_white_list
    %w(in out txt c cpp cc java rb py)
  end
end
