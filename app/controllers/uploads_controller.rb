class UploadsController < ApplicationController
  def create
    @upload = Upload.new(upload_params)
    authorize @upload

    @upload.save
    redirect_to admin_uploads_path
  end

  private

  def upload_params
    params.require(:upload).permit(:upload)
  end
end
