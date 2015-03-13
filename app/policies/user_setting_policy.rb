class UserSettingPolicy < Struct.new(:user, :user_setting)
  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def profile?
    true
  end

  def notification?
    true
  end

  def account?
    true
  end
end
