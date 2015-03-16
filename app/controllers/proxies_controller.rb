class ProxiesController < ApplicationController
  def rabbitmq
    if Rails.env.development? || current_user.admin?
      authorize :static, :home?
      redirect_to '/rabbitmq/'
    else
      render nothing: true, status: 404
    end
  end
end
