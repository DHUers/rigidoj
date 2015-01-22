every 1.minute do
  runner 'ReceiveSolutionResultJob.perform_now'
end
