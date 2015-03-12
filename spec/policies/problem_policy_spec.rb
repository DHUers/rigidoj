require 'spec_helper'

describe ProblemPolicy do
  context 'record' do
    subject { ProblemPolicy.new(current_user, problem) }

    context 'for a visitor' do
      let(:current_user) { nil }

      context 'creating a new problem' do
        let(:problem) { Problem.new }

        it { expect(subject).not_to pundit_permit(:new) }
        it { expect(subject).not_to pundit_permit(:create) }
      end

      context 'with a visible problem' do
        let(:problem) { Fabricate.build :problem }

        it { expect(subject).to pundit_permit(:show) }
        it { expect(subject).not_to pundit_permit(:edit) }
        it { expect(subject).not_to pundit_permit(:update) }
        it { expect(subject).not_to pundit_permit(:destroy) }
      end

      context 'with a invisible problem' do
        let(:problem) { Fabricate.build(:invisible_problem) }

        it { expect(subject).not_to pundit_permit(:show)    }
        it { expect(subject).not_to pundit_permit(:edit)    }
        it { expect(subject).not_to pundit_permit(:update)  }
        it { expect(subject).not_to pundit_permit(:destroy) }
      end
    end

    context 'for normal user' do
      let(:current_user) { Fabricate.build(:user) { groups { [Fabricate.build(:group)] } } }

      context 'creating a new problem' do
        let(:problem) { Problem.new }

        it { expect(subject).not_to pundit_permit(:new) }
        it { expect(subject).not_to pundit_permit(:create) }
      end

      context 'with a visible problem' do
        let(:problem) { Fabricate.build :problem }

        it { expect(subject).to     pundit_permit(:show)    }
        it { expect(subject).not_to pundit_permit(:edit)    }
        it { expect(subject).not_to pundit_permit(:update)  }
        it { expect(subject).not_to pundit_permit(:destroy) }
      end

      context 'with a invisible problem' do
        let(:problem) { Fabricate.build(:invisible_problem) }

        it { expect(subject).not_to pundit_permit(:show)    }
        it { expect(subject).not_to pundit_permit(:edit)    }
        it { expect(subject).not_to pundit_permit(:update)  }
        it { expect(subject).not_to pundit_permit(:destroy) }

        describe 'but visible to its visible group' do
          let(:problem) { Fabricate.build(:problem, visible_to_group: current_user.groups.first) }

          it { expect(subject).to     pundit_permit(:show)    }
          it { expect(subject).not_to pundit_permit(:edit)    }
          it { expect(subject).not_to pundit_permit(:update)  }
          it { expect(subject).not_to pundit_permit(:destroy) }
        end
      end

      context 'for moderator user' do
        let(:current_user) { Fabricate.build(:moderator) { groups { [Fabricate.build(:group)] } } }

        context 'creating a new problem' do
          let(:problem) { Problem.new }

          it { expect(subject).to pundit_permit(:new) }
          it { expect(subject).to pundit_permit(:create) }
        end

        context 'with a visible problem' do
          let(:problem) { Fabricate.build :problem }

          it { expect(subject).to pundit_permit(:show)    }
          it { expect(subject).to pundit_permit(:edit)    }
          it { expect(subject).to pundit_permit(:update)  }
          it { expect(subject).not_to pundit_permit(:destroy) }
        end

        context 'with a invisible problem' do
          let(:problem) { Fabricate.build(:invisible_problem) }

          it { expect(subject).not_to pundit_permit(:show)    }
          it { expect(subject).not_to pundit_permit(:edit)    }
          it { expect(subject).not_to pundit_permit(:update)  }
          it { expect(subject).not_to pundit_permit(:destroy) }

          describe 'but visible to its visible group' do
            let(:problem) { Fabricate.build(:problem, visible_to_group: current_user.groups.first) }

            it { expect(subject).to pundit_permit(:show) }
            it { expect(subject).to pundit_permit(:edit) }
            it { expect(subject).to pundit_permit(:update) }
            it { expect(subject).not_to pundit_permit(:destroy) }
          end
        end
      end

      context 'for admin user' do
        let(:current_user) { Fabricate.build(:admin) { groups { [Fabricate.build(:group)] } } }

        context 'creating a new problem' do
          let(:problem) { Problem.new }

          it { expect(subject).to pundit_permit(:new) }
          it { expect(subject).to pundit_permit(:create) }
        end

        context 'with a visible problem' do
          let(:problem) { Fabricate.build :problem }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).to pundit_permit(:edit) }
          it { expect(subject).to pundit_permit(:update) }
          it { expect(subject).to pundit_permit(:destroy) }
        end

        context 'with a invisible problem' do
          let(:problem) { Fabricate.build(:invisible_problem) }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).to pundit_permit(:edit) }
          it { expect(subject).to pundit_permit(:update) }
          it { expect(subject).to pundit_permit(:destroy) }

          describe 'but visible to its visible group' do
            let(:problem) { Fabricate.build(:problem, visible_to_group: current_user.groups.first) }

            it { expect(subject).to pundit_permit(:show) }
            it { expect(subject).to pundit_permit(:edit) }
            it { expect(subject).to pundit_permit(:update) }
            it { expect(subject).to pundit_permit(:destroy) }
          end
        end
      end
    end
  end

  context 'scope' do
    let(:scope) { Problem }
    subject(:policy_scope) { ProblemPolicy::Scope.new(current_user, scope).resolve }
    before :all do
      @mod1 = Fabricate.build(:moderator) { groups [Fabricate.build(:group)] }
      @mod2 = Fabricate.build(:moderator) { groups [Fabricate.build(:group)] }
      3.times { Fabricate :problem }
      2.times { Fabricate :invisible_problem, visible_to_group: @mod1.groups.first }
      Fabricate :invisible_problem, visible_to_group: @mod2.groups.first
      Fabricate :invisible_problem
    end
    after :all do
      Group.delete_all
      Problem.delete_all
    end

    describe 'normal user can only see visible problems' do
      let(:current_user) { Fabricate.build :user }
      it { expect(subject.count) == 3 }
    end
    describe 'moderator user can see invisible problems with corresponding group' do
      it { expect(ProblemPolicy::Scope.new(@mod1, scope).resolve .count) == 5 }
      it { expect(ProblemPolicy::Scope.new(@mod2, scope).resolve .count) == 4 }
    end
    describe 'admin user can see all problems' do
      let(:current_user) { Fabricate.build :admin }
      it { expect(subject.count) == 7 }
    end

  end
end
