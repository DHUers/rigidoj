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
        let(:contest) { Fabricate.build :contest }

        it { expect(subject).to pundit_permit(:show) }
        it { expect(subject).not_to pundit_permit(:edit) }
        it { expect(subject).not_to pundit_permit(:update) }
        it { expect(subject).not_to pundit_permit(:destroy) }
        it { expect(subject).not_to pundit_permit(:rejudge_solution) }
        it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).not_to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
      end

      context 'with a invisible contest' do
        let(:contest) { Fabricate.build(:invisible_contest) }

        it { expect(subject).not_to pundit_permit(:show) }
        it { expect(subject).not_to pundit_permit(:edit) }
        it { expect(subject).not_to pundit_permit(:update) }
        it { expect(subject).not_to pundit_permit(:destroy) }
        it { expect(subject).not_to pundit_permit(:rejudge_solution) }
        it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).not_to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
      end
    end

    context 'for normal user' do
      let(:current_user) { Fabricate.build(:user) { groups { [Fabricate.build(:group)] } } }

      context 'creating a new contest' do
        let(:contest) { Contest.new }

        it { expect(subject).not_to pundit_permit(:new) }
        it { expect(subject).not_to pundit_permit(:create) }
      end

      context 'with a visible contest' do
        let(:contest) { Fabricate.build(:contest) }

        it { expect(subject).to pundit_permit(:show) }
        it { expect(subject).not_to pundit_permit(:edit) }
        it { expect(subject).not_to pundit_permit(:update) }
        it { expect(subject).not_to pundit_permit(:destroy) }
        it { expect(subject).not_to pundit_permit(:rejudge_solution) }
        it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).not_to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
      end

      context 'with a invisible contest' do
        let(:contest) { Fabricate.build(:invisible_contest) }

        it { expect(subject).not_to pundit_permit(:show) }
        it { expect(subject).not_to pundit_permit(:edit) }
        it { expect(subject).not_to pundit_permit(:update) }
        it { expect(subject).not_to pundit_permit(:destroy) }
        it { expect(subject).not_to pundit_permit(:rejudge_solution) }
        it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).not_to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end

        describe 'but visible to its visible group' do
          let(:contest) { Fabricate.build(:contest, groups: [current_user.groups.first]) }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).not_to pundit_permit(:edit) }
          it { expect(subject).not_to pundit_permit(:update) }
          it { expect(subject).not_to pundit_permit(:destroy) }
          it { expect(subject).not_to pundit_permit(:rejudge_solution) }
          it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
          it { expect(subject).not_to pundit_permit(:send_notification) }

          context 'before the contest begins' do
            Timecop.freeze(2098, 12, 31, 23, 59, 59) do
              it { expect(subject).not_to pundit_permit(:show_details) }
              it { expect(subject).not_to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest begins' do
            Timecop.freeze(2099, 1, 2, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest ends' do
            Timecop.freeze(2099, 1, 4, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).not_to pundit_permit(:create_solution) }
            end
          end
        end

        describe 'but in contest judger group' do
          let(:contest) { Fabricate.build(:contest, judger_group: current_user.groups.first) }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).not_to pundit_permit(:edit) }
          it { expect(subject).not_to pundit_permit(:update) }
          it { expect(subject).not_to pundit_permit(:destroy) }
          it { expect(subject).to pundit_permit(:rejudge_solution) }
          it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
          it { expect(subject).not_to pundit_permit(:send_notification) }

          context 'before the contest begins' do
            Timecop.freeze(2098, 12, 31, 23, 59, 59) do
              it { expect(subject).not_to pundit_permit(:show_details) }
              it { expect(subject).not_to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest begins' do
            Timecop.freeze(2099, 1, 2, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest ends' do
            Timecop.freeze(2099, 1, 4, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
        end
      end
    end

    context 'for moderator user' do
      let(:current_user) { Fabricate.build(:moderator) { groups { [Fabricate.build(:group)] } } }

      context 'creating a new contest' do
        let(:contest) { Contest.new }

        it { expect(subject).to pundit_permit(:new) }
        it { expect(subject).to pundit_permit(:create) }
      end

      context 'with a visible contest' do
        let(:contest) { Fabricate.build(:contest) }

        it { expect(subject).to pundit_permit(:show) }
        it { expect(subject).to pundit_permit(:edit) }
        it { expect(subject).to pundit_permit(:update) }
        it { expect(subject).not_to pundit_permit(:destroy) }
        it { expect(subject).to pundit_permit(:rejudge_solution) }
        it { expect(subject).to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
      end

      context 'with a invisible contest' do
        let(:contest) { Fabricate.build(:invisible_contest) }

        it { expect(subject).not_to pundit_permit(:show) }
        it { expect(subject).not_to pundit_permit(:edit) }
        it { expect(subject).not_to pundit_permit(:update) }
        it { expect(subject).not_to pundit_permit(:destroy) }
        it { expect(subject).not_to pundit_permit(:rejudge_solution) }
        it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).not_to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).not_to pundit_permit(:show_details) }
            it { expect(subject).not_to pundit_permit(:create_solution) }
          end
        end

        describe 'but visible to its visible group' do
          let(:contest) { Fabricate.build(:contest, groups: [current_user.groups.first]) }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).not_to pundit_permit(:edit) }
          it { expect(subject).not_to pundit_permit(:update) }
          it { expect(subject).not_to pundit_permit(:destroy) }
          it { expect(subject).not_to pundit_permit(:rejudge_solution) }
          it { expect(subject).not_to pundit_permit(:rejudge_all_solution) }
          it { expect(subject).not_to pundit_permit(:send_notification) }

          context 'before the contest begins' do
            Timecop.freeze(2098, 12, 31, 23, 59, 59) do
              it { expect(subject).not_to pundit_permit(:show_details) }
              it { expect(subject).not_to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest begins' do
            Timecop.freeze(2099, 1, 2, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest ends' do
            Timecop.freeze(2099, 1, 4, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).not_to pundit_permit(:create_solution) }
            end
          end
        end

        describe 'but in contest judger group' do
          let(:contest) { Fabricate.build(:contest, judger_group: current_user.groups.first) }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).to pundit_permit(:edit) }
          it { expect(subject).to pundit_permit(:update) }
          it { expect(subject).not_to pundit_permit(:destroy) }
          it { expect(subject).to pundit_permit(:rejudge_solution) }
          it { expect(subject).to pundit_permit(:rejudge_all_solution) }
          it { expect(subject).to pundit_permit(:send_notification) }

          context 'before the contest begins' do
            Timecop.freeze(2098, 12, 31, 23, 59, 59) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest begins' do
            Timecop.freeze(2099, 1, 2, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest ends' do
            Timecop.freeze(2099, 1, 4, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
        end
      end
    end

    context 'for admin user' do
      let(:current_user) { Fabricate.build(:admin) { groups { [Fabricate.build(:group)] } } }

      context 'creating a new contest' do
        let(:contest) { Contest.new }

        it { expect(subject).to pundit_permit(:new) }
        it { expect(subject).to pundit_permit(:create) }
      end

      context 'with a visible contest' do
        let(:contest) { Fabricate.build(:contest) }

        it { expect(subject).to pundit_permit(:show) }
        it { expect(subject).to pundit_permit(:edit) }
        it { expect(subject).to pundit_permit(:update) }
        it { expect(subject).to pundit_permit(:destroy) }
        it { expect(subject).to pundit_permit(:rejudge_solution) }
        it { expect(subject).to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
      end

      context 'with a invisible contest' do
        let(:contest) { Fabricate.build(:invisible_contest) }

        it { expect(subject).to pundit_permit(:show) }
        it { expect(subject).to pundit_permit(:edit) }
        it { expect(subject).to pundit_permit(:update) }
        it { expect(subject).to pundit_permit(:destroy) }
        it { expect(subject).to pundit_permit(:rejudge_solution) }
        it { expect(subject).to pundit_permit(:rejudge_all_solution) }
        it { expect(subject).to pundit_permit(:send_notification) }

        context 'before the contest begins' do
          Timecop.freeze(2098, 12, 31, 23, 59, 59) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest begins' do
          Timecop.freeze(2099, 1, 2, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end
        context 'after the contest ends' do
          Timecop.freeze(2099, 1, 4, 0) do
            it { expect(subject).to pundit_permit(:show_details) }
            it { expect(subject).to pundit_permit(:create_solution) }
          end
        end

        describe 'but visible to its visible group' do
          let(:contest) { Fabricate.build(:contest, groups: [current_user.groups.first]) }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).to pundit_permit(:edit) }
          it { expect(subject).to pundit_permit(:update) }
          it { expect(subject).to pundit_permit(:destroy) }
          it { expect(subject).to pundit_permit(:rejudge_solution) }
          it { expect(subject).to pundit_permit(:rejudge_all_solution) }
          it { expect(subject).to pundit_permit(:send_notification) }

          context 'before the contest begins' do
            Timecop.freeze(2098, 12, 31, 23, 59, 59) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest begins' do
            Timecop.freeze(2099, 1, 2, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest ends' do
            Timecop.freeze(2099, 1, 4, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
        end

        describe 'but in contest judger group' do
          let(:contest) { Fabricate.build(:contest, judger_group: current_user.groups.first) }

          it { expect(subject).to pundit_permit(:show) }
          it { expect(subject).to pundit_permit(:edit) }
          it { expect(subject).to pundit_permit(:update) }
          it { expect(subject).to pundit_permit(:destroy) }
          it { expect(subject).to pundit_permit(:rejudge_solution) }
          it { expect(subject).to pundit_permit(:rejudge_all_solution) }
          it { expect(subject).to pundit_permit(:send_notification) }

          context 'before the contest begins' do
            Timecop.freeze(2098, 12, 31, 23, 59, 59) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest begins' do
            Timecop.freeze(2099, 1, 2, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
          context 'after the contest ends' do
            Timecop.freeze(2099, 1, 4, 0) do
              it { expect(subject).to pundit_permit(:show_details) }
              it { expect(subject).to pundit_permit(:create_solution) }
            end
          end
        end
      end
    end
  end
end
