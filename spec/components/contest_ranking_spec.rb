require 'spec_helper'
require 'active_support/time'

describe ContestRanking do
  describe "when the contest wont't be frozen" do
    before :context do
      User.delete_all
      Problem.delete_all
      @contest = Fabricate(:contest)
      @user1 = @contest.users[0]
      @user2 = @contest.users[1]
      @ranking = ContestRanking.new(@user1, @contest)
    end
    after :context do
      Contest.delete_all
    end

    context '.frozen?' do
      it 'always false' do
        expect(@ranking.frozen?(@user1.id)).to be false
        expect(@ranking.frozen?(@user2.id)).to be false
      end
    end
  end

  describe "when the contest will be frozen" do
    before :context do
      User.delete_all
      Problem.delete_all
      @contest = Fabricate(:frozen_contest)
      @user1 = @contest.users[0]
      @user2 = @contest.users[1]
      @admin = Fabricate(:admin)
      @ranking = ContestRanking.new(@user1, @contest)
    end
    after :context do
      User.delete_all
      Contest.delete_all
    end

    describe '.frozen?' do
      describe 'in the beginning' do
        before do
          Timecop.freeze(Time.zone.local(2099, 1, 1, 10, 0, 0))
        end
        after do
          Timecop.return
        end
        it 'always false' do
          expect(@ranking.frozen?(@user1.id)).to be false
          expect(@ranking.frozen?(@user2.id)).to be false
        end
      end


      describe 'reaches the frozen time' do
        before do
          Timecop.freeze(Time.zone.local(2099, 1, 2, 10, 0, 0))
        end
        after do
          Timecop.return
        end

        it 'false to operator' do
          expect(@ranking.frozen?(@user1.id)).to be false
        end

        it 'true to others' do
          expect(@ranking.frozen?(@user2.id)).to be true
        end

        it 'false when the user is admin' do
          ranking = ContestRanking.new(@admin, @contest)
          expect(ranking.frozen?(@admin.id)).to be false
        end

        it 'false when skipped' do
          ranking = ContestRanking.new(@user2, @contest, skip_frozen: true)
          expect(ranking.frozen?(@user2.id)).to be false
        end
      end


      describe 'after the contest ends' do
        before do
          Timecop.freeze(Time.zone.local(2099, 1, 3, 10, 0, 0))
        end
        after do
          Timecop.return
        end

        it 'shows whatever after the contest ends' do
          expect(@ranking.frozen?(@user1.id)).to be false
          expect(@ranking.frozen?(@user2.id)).to be false
        end
      end

    end
  end
end
