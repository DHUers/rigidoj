class GroupsController < ApplicationController
  def index
    @groups = policy_scope(Group).order(:id).page(params[:page]).per(20)
  end

  def new
    @group = Group.new
    @group.users << current_user
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to group_path(@group.name)
    else
      flash[:danger] = 'There is something wrong in the form.'
      render 'new'
    end

  end

  def show
    @group = Group.find_by(group_name: params[:group_name])
    authorize @group
  end

  def edit
    @group = Group.find_by(group_name: params[:group_name])
  end

  def person
    @user = User.find_by(username_lower: params[:username])
    authorize @user, :show?
    render 'users/show'
  end

  private

  def group_params
    params.require(:group).permit(:name, :user_ids => [])
  end

end
