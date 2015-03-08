class UserSettingPolicy < Struct.new(:user, :user_setting)
  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def profile?
    true
  end

  def about?
    true
  end

  def help?
    true
  end
end
