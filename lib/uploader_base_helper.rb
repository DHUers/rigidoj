module UploaderBaseHelper
  extend ActiveSupport::Concern

  included do
    after :remove, :delete_empty_upstream_dirs

    def filename
      "#{uuid}.#{file.extension}" if original_filename.present?
    end

    def uuid
      reader_var = :"#{mounted_as}_uuid"
      writer_var = :"#{mounted_as}_uuid="
      model.send(reader_var) or model.send(writer_var, SecureRandom.uuid)
    end

    private

    def delete_empty_upstream_dirs
      path = ::File.expand_path(store_dir, root)
      Dir.delete(path) # fails if path not empty dir
    rescue SystemCallError
      true # nothing, the dir is not empty
    end
  end
end
