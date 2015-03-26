class UsersController < ApplicationController
  def search_users
    authorize current_user, :search?

    term = params[:term].to_s.strip
    users = User.where(active: true).order(User.sql_fragment("CASE WHEN username = ? THEN 0 ELSE 1 END ASC", term.downcase))

    if term.present?
      query = Search.ts_query(term)
      term_like = "#{term.downcase}%"
      users = users.includes(:user_search_datas)
                   .references(:user_search_datas)
                   .where("username LIKE :term_like OR user_search_datas.search_data @@ #{query}",
                          term: term, term_like: term_like)
                   .order(User.sql_fragment("CASE WHEN username LIKE ? THEN 0 ELSE 1 END ASC", term_like))
    end

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
    @problems = policy_scope(Problem)
                    .includes(:user_problem_stats)
                    .where(user_problem_stats: { user_id: @user.id })
                    .where.not(user_problem_stats: { state: 'null' })
                    .order(:id)
                    .page(params[:page])
                    .per(30)
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
    if user && current_user != user
      user.block = !user.block
      user.active = !user.block
      user.save!

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
