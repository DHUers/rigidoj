class ResolveSolutionResultJob < ActiveJob::Base
  queue_as :critical

  def perform(*args)
    # Do something later
  end
end
