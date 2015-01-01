module UploaderOriginalFilenameHelper
  extend ActiveSupport::Concern

  included do
    before :cache, :save_original_filename

    private

    def save_original_filename(file)
      var = :"#{mounted_as}_original_filename="
      model.send(var, file.original_filename) if file.respond_to?(:original_filename)
    end
  end
end
