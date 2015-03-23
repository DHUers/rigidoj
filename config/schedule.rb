every 15.minutes do
  runner 'AnnounceContestJob.perform_now'
end
