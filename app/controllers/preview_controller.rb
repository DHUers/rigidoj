class PreviewController < ApplicationController
  def problem
    render text: PrettyText::cook(params[:raw]), status: 200
  end

end
