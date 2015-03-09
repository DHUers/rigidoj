class SessionPolicy < Struct.new(:user, :session)
  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def login?
    true
  end

  def logout?
    true
  end
end
