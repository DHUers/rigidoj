class Admin::AdminBaseController < ApplicationController
  before_filter :authorize_admin

  def authorize_admin
    authorize :user, :admin?
  end
end