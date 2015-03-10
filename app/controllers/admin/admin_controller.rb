class Admin::AdminController < Admin::AdminBaseController
  def dashboard
    render 'admin/admin/dashboard'
  end

  def show_settings
    unless SiteSetting.category_listings.include? params[:category]
      return redirect_to admin_settings_path
    end

    @settings = filter_settings_in_a_category

    render 'admin/admin/settings'
  end

  def update_settings
    unless SiteSetting.category_listings.include? params[:category]
      return :nothing, status: 404
    end

    updated_settings = settings_params

    if SiteSetting.set_new_hash(updated_settings)
      flash[:success] = 'Successfully updated.'
      redirect_to admin_settings_path
    else

    end
  end

  def groups
  end

  private

  def filter_settings_in_a_category
    SiteSetting.all_settings.delete_if { |setting|
      setting[:category] != params[:category] }
  end

  def settings_params
    params.require(:settings).permit(
        filter_settings_in_a_category.map {|s| s[:setting]})
  end
end
