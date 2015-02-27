require 'spec_helper'
require 'active_support/time'

describe ContestRanking do
  describe "when the contest wont't be frozen" do
    before :all do
      User.delete_all
      Problem.delete_all
      @contest = Fabricate(:contest)
      @user1 = @contest.users[0]
      @user2 = @contest.users[1]
      @ranking = ContestRanking.new(@user1, @contest)
    end
    after :all do
      Contest.delete_all
    end

    context '.frozen?' do
      it 'always false' do
        expect(@ranking.frozen?(@user1.id)).to be false
        expect(@ranking.frozen?(@user2.id)).to be false
      end
    end

    describe 'solutions ranking' do
      #         problem 1   problem 2   problem 3
      # user 1  1WA, 2AC    1AC         1WA
      # user 2  1WA, 1JU    1JA         1WA, 1AC
      # user 3  1JU         2WA         2AC
      before :all do
        @user1 = @contest.users[0]
        @user2 = @contest.users[1]
        @user3 = @contest.users[2]
        @problem1 = @contest.problems[0]
        @problem2 = @contest.problems[1]
        @problem3 = @contest.problems[2]
        @time1 = Time.zone.local(2099, 1, 1, 12) # 2099-01-01 12:00
        @time2 = Time.zone.local(2099, 1, 1, 13) # 2099-01-01 13:00
        @time3 = Time.zone.local(2099, 1, 1, 14) # 2099-01-01 14:00

        @solutions = []
        @solutions << Fabricate(:solution, user_id: @user1.id, problem_id: @problem1.id, contest_id: @contest.id,
                                created_at: @time1, status: :wrong_answer)
        @solutions << Fabricate(:solution, user_id: @user1.id, problem_id: @problem1.id, contest_id: @contest.id,
                                created_at: @time2, status: :accepted_answer)
        @solutions << Fabricate(:solution, user_id: @user1.id, problem_id: @problem1.id, contest_id: @contest.id,
                                created_at: @time3, status: :accepted_answer)
        @solutions << Fabricate(:solution, user_id: @user1.id, problem_id: @problem2.id, contest_id: @contest.id,
                                created_at: @time1, status: :accepted_answer)
        @solutions << Fabricate(:solution, user_id: @user1.id, problem_id: @problem3.id, contest_id: @contest.id,
                                created_at: @time1, status: :wrong_answer)

        @solutions << Fabricate(:solution, user_id: @user2.id, problem_id: @problem1.id, contest_id: @contest.id,
                                created_at: @time1, status: :wrong_answer)
        @solutions << Fabricate(:solution, user_id: @user2.id, problem_id: @problem1.id, contest_id: @contest.id,
                                created_at: @time2, status: :judging)
        @solutions << Fabricate(:solution, user_id: @user2.id, problem_id: @problem2.id, contest_id: @contest.id,
                                created_at: @time1, status: :judge_error)
        @solutions << Fabricate(:solution, user_id: @user2.id, problem_id: @problem3.id, contest_id: @contest.id,
                                created_at: @time1, status: :wrong_answer)
        @solutions << Fabricate(:solution, user_id: @user2.id, problem_id: @problem3.id, contest_id: @contest.id,
                                created_at: @time2, status: :accepted_answer)

        @solutions << Fabricate(:solution, user_id: @user3.id, problem_id: @problem1.id, contest_id: @contest.id,
                                created_at: @time1, status: :judging)
        @solutions << Fabricate(:solution, user_id: @user3.id, problem_id: @problem2.id, contest_id: @contest.id,
                                created_at: @time1, status: :wrong_answer)
        @solutions << Fabricate(:solution, user_id: @user3.id, problem_id: @problem2.id, contest_id: @contest.id,
                                created_at: @time2, status: :wrong_answer)
        @solutions << Fabricate(:solution, user_id: @user3.id, problem_id: @problem3.id, contest_id: @contest.id,
                                created_at: @time1, status: :accepted_answer)
        @solutions << Fabricate(:solution, user_id: @user3.id, problem_id: @problem3.id, contest_id: @contest.id,
                                created_at: @time2, status: :accepted_answer)

        @user1_solutions = @solutions.select { |s| s.user_id == @user1.id }
        @user2_solutions = @solutions.select { |s| s.user_id == @user2.id }
        @user3_solutions = @solutions.select { |s| s.user_id == @user3.id }
      end
      after :all do
        Solution.delete_all
      end

      describe '.filter_solutions' do
        it 'user1' do
          p1 = @user1_solutions.select { |s| s.problem_id == @problem1.id }
          p2 = @user1_solutions.select { |s| s.problem_id == @problem2.id }
          p3 = @user1_solutions.select { |s| s.problem_id == @problem3.id }
          expect(@ranking.filter_solutions(@problem1.id, p1)).to match_array [@problem1.id, [true, 2, 320]]
          expect(@ranking.filter_solutions(@problem2.id, p2)).to match_array [@problem2.id, [true, 1, 240]]
          expect(@ranking.filter_solutions(@problem3.id, p3)).to match_array [@problem3.id, [false, 1]]
        end

        it 'user2' do
          p1 = @user2_solutions.select { |s| s.problem_id == @problem1.id }
          p2 = @user2_solutions.select { |s| s.problem_id == @problem2.id }
          p3 = @user2_solutions.select { |s| s.problem_id == @problem3.id }
          expect(@ranking.filter_solutions(@problem1.id, p1)).to match_array [@problem1.id, [false, 2]]
          expect(@ranking.filter_solutions(@problem2.id, p2)).to match_array [@problem2.id, [false, 0]]
          expect(@ranking.filter_solutions(@problem3.id, p3)).to match_array [@problem3.id, [true, 2, 320]]
        end

        it 'user3' do
          p1 = @user3_solutions.select { |s| s.problem_id == @problem1.id }
          p2 = @user3_solutions.select { |s| s.problem_id == @problem2.id }
          p3 = @user3_solutions.select { |s| s.problem_id == @problem3.id }
          expect(@ranking.filter_solutions(@problem1.id, p1)).to match_array [@problem1.id, [false, 1]]
          expect(@ranking.filter_solutions(@problem2.id, p2)).to match_array [@problem2.id, [false, 2]]
          expect(@ranking.filter_solutions(@problem3.id, p3)).to match_array [@problem3.id, [true, 1, 240]]
        end
      end
    end
  end

  describe "when the contest will be frozen" do
    before :all do
      User.delete_all
      Problem.delete_all
      @contest = Fabricate(:frozen_contest)
      @user1 = @contest.users[0]
      @user2 = @contest.users[1]
      @admin = Fabricate(:admin)
      @ranking = ContestRanking.new(@user1, @contest)
    end
    after :all do
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
