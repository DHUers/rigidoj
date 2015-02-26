require 'spec_helper'

describe ContestRanking do
  skip 'all' do
    before :context do
      @user1 = Fabricate(:user)
      @user2 = Fabricate(:user)
      @admin = Fabricate(:admin)
    end
    after :context do
      User.delete_all
    end

    describe "when the contest wont't be frozen" do
      before :context do
        @contest = Fabricate(:contest)
        @ranking = ContestRanking.new(@user1, @contest, [@user1, @user2])
      end
      after :context do
        Contest.delete_all
      end

      context '.frozen_status?' do
        it 'always false' do
          expect(@ranking.frozen_status?(@user1)).to be false
          expect(@ranking.frozen_status?(@user2)).to be false
        end
      end
    end

    describe "when the contest will be frozen" do
      before :context do
        @contest = Fabricate(:frozen_contest)
        @ranking = ContestRanking.new(@user1, @contest, [@user1, @user2])
      end
      after :context do
        Contest.delete_all
      end

      describe '.frozen_status?' do
        describe 'in the beginning' do
          it 'always false' do
            expect(@ranking.frozen_status?(@user1)).to be false
            expect(@ranking.frozen_status?(@user2)).to be false
          end
        end

        describe 'reaches the frozen time' do
          before do
            Timecop.freeze(@contest.frozen_ranking_from.since(1.minute))
          end
          after do
            Timecop.return
          end

          it 'always true for others' do
            expect(@ranking.frozen_status?(@user1)).to be true
            expect(@ranking.frozen_status?(@user2)).to be true
          end

          it 'false when the user is admin' do
            ranking = ContestRanking.new(@admin, @contest, [@user1, @user2])
            expect(ranking.frozen_status?(@admin)).to be false
          end
        end

        describe 'after the contest ends' do
          before do
            Timecop.freeze(@contest.end_at.since(1.minute))
          end
          after do
            Timecop.return
          end

          it 'shows after the contest ends' do
            expect(@ranking.frozen_status?(@user1)).to be false
            expect(@ranking.frozen_status?(@user2)).to be false
          end
        end

      end
    end
  end
end
