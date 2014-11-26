class SilenceLogger < Rails::Rack::Logger
  PATH_INFO = 'PATH_INFO'.freeze

  def initialize(app, opts = {})
    @app = app
    @opts = opts
    @opts[:silenced] ||= []

    # Rails introduces something called taggers in the Logger, needs to be initialized
    super(app)
  end

  def call(env)
    prev_level = Rails.logger.level
    path_info = env[PATH_INFO]

    if @opts[:silenced].include?(path_info) ||
       path_info.start_with?('/assets')
      Rails.logger.level = Logger::WARN
      @app.call(env)
    else
      super(env)
    end
  ensure
    Rails.logger.level = prev_level
  end
end

silenced = [
    "/mini-profiler-resources/results".freeze,
    "/mini-profiler-resources/includes.js".freeze,
    "/mini-profiler-resources/includes.css".freeze,
    "/mini-profiler-resources/jquery.tmpl.js".freeze
]
Rails.configuration.middleware.swap Rails::Rack::Logger, SilenceLogger, silenced: silenced
