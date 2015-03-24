class UsersController < ApplicationController
  def search_users
    authorize current_user, :search?

    term = params[:term].to_s.strip
    users = User.order(User.sql_fragment("CASE WHEN username_lower = ? THEN 0 ELSE 1 END ASC", term.downcase))
    if term.present?
      query = Search.ts_query(@term, "simple")
      users = users.includes(:user_search_data)
                   .references(:user_search_data)
                   .where("username_lower LIKE :term_like OR user_search_data.search_data @@ #{query}",
                          term: @term, term_like: @term_like)
                   .order(User.sql_fragment("CASE WHEN username_lower LIKE ? THEN 0 ELSE 1 END ASC", @term_like))
    end

    users.order("CASE WHEN last_seen_at IS NULL THEN 0 ELSE 1 END DESC, last_seen_at DESC, username ASC")
         .limit(@limit)

    render_serialized(users, BasicUserSerializer)
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      flash[:success] = "Successfully created your account. You can log in now."
      redirect_to login_path
    else
      flash[:danger] = "There were problems creating your account."
      render 'new'
    end
  end

  def show
    @user = User.includes(:groups).find_by(username_lower: params[:username].downcase)
    authorize @user
    @groups = @user.groups
    @problems = policy_scope(Problem).includes(:user_problem_stats).where(user_problem_stats: { user_id: @user.id }).order(:id).page(params[:page]).per(30)
  end

  def edit
    @user = User.find_by(username_lower: params[:username])
    authorize @user
  end

  def is_local_username
    params.require(:username)
    u = params[:username].downcase
    r = User.exec_sql('SELECT 1 FROM users WHERE username_lower = ?', u).values
    render json: {valid: r.length == 1}
  end

  def grant_admin
    user = User.find_by(username: params[:username])
    authorize current_user, :admin?
    if user
      user.update_attribute(:admin, !user.admin) unless current_user == user

      redirect_to user_path(user)
    else
      render nothing: 200
    end
  end

  def grant_moderator
    user = User.find_by(username: params[:username])
    authorize current_user, :admin?
    if user
      user.update_attribute(:moderator, !user.moderator) unless current_user == user

      redirect_to user_path(user)
    else
      render nothing: 200
    end
  end

  def block
    user = User.find_by(username: params[:username])
    authorize current_user, :admin?
    if user
      user.update_attribute(:block, !user.block) unless current_user == user

      redirect_to user_path(user)
    else
      render nothing: 200
    end
  end

  private

  def user_params
    params.require(:user).permit(*policy(@user || User).permitted_attributes)
  end
end
