module Rigidoj

  SYSTEM_USER_ID = -1 unless defined? SYSTEM_USER_ID

  def self.system_user
    User.find_by(id: SYSTEM_USER_ID)
  end

  def self.rabbitmq_connection
    unless @rabbitmq_connection
      @rabbitmq_connection = Bunny.new
      @rabbitmq_connection.start
    end
    @rabbitmq_connection
  end

  def self.rabbitmq_channel
    @rabbitmq_channel ||= self.rabbitmq_connection.create_channel
  end

  JUDGER_QUEUE_NAME = 'judger_queue' unless defined? JUDGER_QUEUE_NAME
  RESULT_QUEUE_NAME = 'result_queue' unless defined? RESULT_QUEUE_NAME

  def self.judger_queue
    unless @judger_queue
      @judger_queue = self.rabbitmq_channel.queue(JUDGER_QUEUE_NAME, durable: true)
    end
    @judger_queue
  end

  def self.result_queue
    unless @result_queue
      @result_queue = self.rabbitmq_channel.queue(RESULT_QUEUE_NAME)
    end
    @result_queue
  end

  def self.subscribe_judger_results
    @result_queue.subscribe do |delivery_info, properties, payload|
      ResolveSolutionResultJob.perform_later payload
    end
  end

end
