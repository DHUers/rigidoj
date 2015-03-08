describe ProblemPolicy do
  subject { ProblemPolicy.new(current_user, problem) }

  context "for a user" do
    let(:user) { Fabricate :user }
    let(:admin) { Fabricate :user }

    context "creating a new problem" do
      let(:problem) { Problem.new }

      it { should permit(:new) }
      it { should permit(:create) }
    end

    context "with a note someone else created" do
      let(:note) { build_stubbed :note, user: build(:user) }

      it { should     permit(:show)    }
      it { should_not permit(:edit)    }
      it { should_not permit(:update)  }
      it { should_not permit(:destroy) }
    end

    context "with a note that I created" do
      let(:note) { build_stubbed :note, user: current_user }

      it { should     permit(:show)    }
      it { should     permit(:edit)    }
      it { should     permit(:update)  }
      it { should     permit(:destroy) }
    end
  end
end
