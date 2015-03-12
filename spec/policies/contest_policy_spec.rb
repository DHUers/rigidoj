require 'spec_helper'

describe ContestPolicy do
  context 'record' do
    subject { ContestPolicy.new(current_user, contest) }

    context 'for a visitor' do
      let(:current_user) { nil }

      context 'creating a new contest' do
        let(:contest) { Contest.new }

        it { expect(subject).not_to pundit_permit(:new) }
        it { expect(subject).not_to pundit_permit(:create) }
      end

      context 'with a visible contest' do
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
end
