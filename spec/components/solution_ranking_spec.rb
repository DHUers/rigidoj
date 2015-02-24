require 'spec_helper'

describe SolutionRanking do
  let(:user) {Fabricate(:user)}
  let(:admin) {Fabricate(:admin)}

  describe '.user_status' do
    before :all do
      contest = Fabricate(:contest)
      SolutionRanking.new
    end
  end
end
