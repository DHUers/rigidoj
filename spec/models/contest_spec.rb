require 'spec_helper'

describe Contest do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description_raw }
  it_behaves_like 'slugable'

  describe 'factory' do
    before { @contest = Fabricate :contest }
    after { @contest.destroy }

    it 'has a valid factory' do
      expect(@contest).to be_valid
    end
  end

  it 'is invalid without a title' do
    expect(Fabricate.build(:contest, title: '')).not_to be_valid
  end

  it 'is invalid without a description_raw' do
    expect(Fabricate.build(:contest, description_raw: '')).not_to be_valid
  end

  describe '.duration_with_started_at_in_minute' do
    before { @contest = Fabricate :contest }
    after { @contest.destroy }

    it 'should be ceiled to the minute' do
      @time1 = Time.zone.local(2099, 1, 1, 6, 0, 0)  # 2099-01-01 06:00:00
      @time2 = Time.zone.local(2099, 1, 1, 5, 59, 1) # 2099-01-01 05:59:01
      expect(@contest.duration_with_started_at_in_minute(@time1)).to eq 360
      expect(@contest.duration_with_started_at_in_minute(@time2)).to eq 360
    end
  end

  describe '.frozen_from_stareted_at_in_minute' do
    before { @contest = Fabricate :contest }
    after { @contest.destroy }

    it 'should be the minutes to the end time if frozen_from is not exists' do
      expect(@contest.frozen_from_stareted_at_in_minute).to eq 48 * 60
    end

    it 'should be the exact minutes if frozen_from is exists' do
      @contest.frozen_ranking_from = '2099-01-02 00:00'
      expect(@contest.frozen_from_stareted_at_in_minute).to eq 24 * 60
    end
  end

  describe 'time helper' do
    before { @contest = Fabricate :frozen_contest }
    after { @contest.destroy }

    describe '.end_time' do
      it 'expects to the end_at time' do
        expect(@contest.end_time).to eq @contest.end_at
      end
    end

    describe '.started?' do
      it 'should be false before the contest begins' do
        Timecop.freeze(2098, 12, 31, 23, 59, 59) do
          expect(@contest.started?).to be_falsey
        end
      end

      it 'should be true after the contest begins' do
        Timecop.freeze(2099, 1, 1) do
          expect(@contest.started?).to be_truthy
        end
      end

      it 'should be true after the contest ends' do
        Timecop.freeze(2099, 1, 3, 0, 0, 1) do
          expect(@contest.started?).to be_truthy
        end
      end
    end

    describe '.ongoing?' do
      it 'should be false before the contest begins' do
        Timecop.freeze(2098, 12, 31, 23, 59, 59) do
          expect(@contest.ongoing?).to be_falsey
        end
      end

      it 'should be true after the contest begins' do
        Timecop.freeze(2099, 1, 1) do
          expect(@contest.ongoing?).to be_truthy
        end
      end

      it 'should be false after the contest ends' do
        Timecop.freeze(2099, 1, 3, 0, 0, 1) do
          expect(@contest.ongoing?).to be_falsey
        end
      end
    end

    describe '.ended?' do
      it 'should be false before the contest begins' do
        Timecop.freeze(2098, 12, 31, 23, 59, 59) do
          expect(@contest.ended?).to be_falsey
        end
      end

      it 'should be false after the contest begins' do
        Timecop.freeze(2099, 1, 1) do
          expect(@contest.ended?).to be_falsey
        end
      end

      it 'should be true after the contest ends' do
        Timecop.freeze(2099, 1, 3, 0, 0, 0) do
          expect(@contest.ended?).to be_truthy
        end
      end
    end

    describe '.delayed?' do
      it 'should be false before the contest begins' do
        Timecop.freeze(2098, 12, 31, 23, 59, 59) do
          expect(@contest.delayed?).to be_falsey
        end
      end

      it 'should be false after the contest begins' do
        Timecop.freeze(2099, 1, 1) do
          expect(@contest.delayed?).to be_falsey
        end
      end

      it 'should be false after the contest ends' do
        Timecop.freeze(2099, 1, 3, 0, 0, 1) do
          expect(@contest.delayed?).to be_falsey
        end
      end
    end
  end

end
