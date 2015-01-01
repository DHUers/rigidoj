module UploaderBaseHelper
  extend ActiveSupport::Concern

  included do
    before :cache, :save_original_filename
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

    def save_original_filename(file)
      var = :"#{mounted_as}_original_filename="
      model.send(var, file.original_filename) if file.respond_to?(:original_filename)
    end

    def delete_empty_upstream_dirs
      path = ::File.expand_path(store_dir, root)
      Dir.delete(path) # fails if path not empty dir
    rescue SystemCallError
      true # nothing, the dir is not empty
    end
  end
end
