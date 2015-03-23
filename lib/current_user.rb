module CurrentUser

  def self.has_auth_cookie?(env)
    DefaultCurrentUserProvider.new(env).has_auth_cookie?
  end

  def self.lookup_from_env(env)
    DefaultCurrentUserProvider.new(env).current_user
  end

  # can be used to pretend current user does no exist, for CSRF attacks
  def clear_current_user
    @current_user_provider = DefaultCurrentUserProvider.new({})
  end

  def log_on_user(user)
    current_user_provider.log_on_user(user, session, cookies)
  end

  def log_off_user
    current_user_provider.log_off_user(session, cookies)
  end

  def current_user
    current_user_provider.current_user
  end

  class DefaultCurrentUserProvider
    CURRENT_USER_KEY ||= "_RIGIDOJ_CURRENT_USER".freeze
    TOKEN_COOKIE ||= "_t".freeze

    # do all current user initialization here
    def initialize(env)
      @env = env
      @request = Rack::Request.new(env)
    end

    # our current user, return nil if none is found
    def current_user
      return @env[CURRENT_USER_KEY] if @env.key?(CURRENT_USER_KEY)

      request = @request

      auth_token = request.cookies[TOKEN_COOKIE]

      current_user = nil

      if auth_token && auth_token.length == 32
        current_user = User.find_by(auth_token: auth_token)
      end

      if current_user.blocked?
        current_user = nil
      end

      @env[CURRENT_USER_KEY] = current_user
    end

    def log_on_user(user, session, cookies)
      unless user.auth_token && user.auth_token.length == 32
        user.auth_token = SecureRandom.hex(16)
        user.save!
      end
      cookies.permanent[TOKEN_COOKIE] = { value: user.auth_token, httponly: true }
      make_developer_admin(user)
      @env[CURRENT_USER_KEY] = user
    end

    def make_developer_admin(user)
      if  user.active? &&
          !user.admin &&
              Rails.configuration.respond_to?(:developer_emails) &&
              Rails.configuration.developer_emails.include?(user.email)
        user.admin = true
        user.save
      end
    end

    def log_off_user(session, cookies)
      if user = current_user
        user.auth_token = nil
        user.save!
      end
      cookies[TOKEN_COOKIE] = nil
    end
  end

  private

  def current_user_provider
    @current_user_provider ||= DefaultCurrentUserProvider.new(request.env)
  end
end
