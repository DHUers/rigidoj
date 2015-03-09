require 'spec_helper'

describe Problem do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :raw }
  it_behaves_like 'slugable'

  describe 'factory' do
    before { @problem = Fabricate :problem }
    after { @problem.destroy }

    it 'has a valid factory' do
      expect(@problem).to be_valid
    end
  end

  it 'is invalid without a title' do
    expect(Fabricate.build(:problem, title: '')).not_to be_valid
  end

  it 'is invalid without a raw' do
    expect(Fabricate.build(:problem, raw: '')).not_to be_valid
  end

  describe '.judge_limits' do
    before { @problem = Fabricate(:problem) }
    after { @problem.destroy }

    it 'can generates default limits' do
      expect(@problem.judge_limits).to have_key :default
      expect(@problem.judge_limits[:default]).to have_key :time
      expect(@problem.judge_limits[:default]).to have_key :memory
    end
  end
end
