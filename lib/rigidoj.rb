require 'bunny'

module Rigidoj

  SYSTEM_USER_ID = -1 unless defined? SYSTEM_USER_ID
  JUDGER_QUEUE_NAME = 'judger_queue' unless defined? JUDGER_QUEUE_NAME
  JUDGER_PROXY_QUEUE_NAME = 'judger_proxy_queue' unless defined? JUDGER_PROXY_QUEUE_NAME
  RESULT_QUEUE_NAME = 'result_queue' unless defined? RESULT_QUEUE_NAME

  def self.system_user
    User.find_by(id: SYSTEM_USER_ID)
  end

  def self.after_fork
    start_rabbitmq
  end

  def self.start_rabbitmq
    require 'bunny'

    # the following is *required* for Rails + "preload_app true",
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.establish_connection

    $rabbitmq_connection = Bunny.new
    $rabbitmq_connection.start

    $rabbitmq_channel = $rabbitmq_connection.create_channel
    $rabbitmq_judger_queue = $rabbitmq_channel.queue(JUDGER_QUEUE_NAME, durable: true)
    $rabbitmq_judger_proxy_queue = $rabbitmq_channel.queue(JUDGER_PROXY_QUEUE_NAME, durable: true)
    $rabbitmq_result_queue = $rabbitmq_channel.queue(RESULT_QUEUE_NAME, auto_delete: false)
    $rabbitmq_result_queue.subscribe do |delivery_info, properties, payload|
      Rails.logger.info "[Solution result consumer] #{$rabbitmq_result_queue.name} received a message: #{payload}"
    end
  rescue Bunny::ChannelAlreadyClosed
    Rails.logger.error "Queue is closed."
  end

end
