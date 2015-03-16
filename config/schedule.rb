every 15.minute do
  runner 'AnnounceContestJob.perform_now'
end
