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

  def group
    @group = Group.find_by(group_name: params[:group_name])
    authorize @group, :admin?
  end

  def create_group
    @group = Group.new(group_name: params[:group_name], name: params[:name])
    authorize @group, :create?

    if @group.save
      redirect_to admin_groups_path
    else
      flash[:danger] = 'Error when create group.'
      render admin_groups_path
    end
  end

  def update_group
    @group = Group.find_by(group_name: params[:group_name])
    authorize @group, :update?

    if @group.update_attributes(group_params)
      flash[:success] = 'Successfully updated the group.'
    else
      flash[:danger] = 'Error when updating group.'
    end
    redirect_to admin_group_path(@group.group_name)
  end

  def uploads_index
    @uploads = Upload.all
    authorize @uploads, :create?
    @upload = Upload.new

    render 'admin/admin/uploads_index'
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

  def group_params
    params.require(:group).permit(:group_name, :name, :user_ids => [])
  end

end
