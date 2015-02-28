require 'spec_helper'

describe Contest do
  describe '.duration_with_started_at_in_minute' do
    before do
      @contest = Fabricate :contest
    end

    it 'should be ceiled to the minute' do
      @time1 = Time.zone.local(2099, 1, 1, 14, 0, 0)  # 2099-01-01 14:00:00
      @time2 = Time.zone.local(2099, 1, 1, 13, 59, 1) # 2099-01-01 13:59:01
      expect(@contest.duration_with_started_at_in_minute(@time1)).to eq 360
      expect(@contest.duration_with_started_at_in_minute(@time2)).to eq 360
    end
  end
end
