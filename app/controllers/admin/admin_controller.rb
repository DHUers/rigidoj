class Admin::AdminController < ApplicationController
  def dashboard
    render 'admin/admin/dashboard'
  end

  def required
    render 'admin/admin/settings/required'
  end

  def general
    render 'admin/admin/settings/general'
  end
end
