class StaticPolicy < Struct.new(:user, :static)
  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def home?
    true
  end

  def landing?
    true
  end

  def about?
    true
  end

  def help?
    true
  end

  def search?
    true
  end
end
