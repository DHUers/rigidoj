class PreviewController < ApplicationController
  def preview_text
    authorize :static, :home?
    render text: PrettyText::cook(params[:raw]), status: 200
  end

end
