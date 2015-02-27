require 'spec_helper'

describe User do

  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :email }

  describe 'change_username' do
    let(:user) { Fabricate(:user) }

    context 'success' do
      let(:new_username) { "#{user.username}1" }

      before do
        @result = user.change_username(new_username)
      end

      it 'returns true' do
        expect(@result).to eq(true)
      end

      it 'should change the username' do
        user.reload
        expect(user.username).to eq(new_username)
      end

      it 'should change the username_lower' do
        user.reload
        expect(user.username_lower).to eq(new_username.downcase)
      end
    end

    context 'failure' do
      let(:wrong_username) { '' }
      let(:username_before_change) { user.username }
      let(:username_lower_before_change) { user.username_lower }

      before do
        @result = user.change_username(wrong_username)
      end

      it 'returns false' do
        expect(@result).to eq(false)
      end

      it 'should not change the username' do
        user.reload
        expect(user.username).to eq(username_before_change)
      end

      it 'should not change the username_lower' do
        user.reload
        expect(user.username_lower).to eq(username_lower_before_change)
      end
    end

    describe 'change the case of my username' do
      let!(:myself) { Fabricate(:user, username: 'hansolo') }

      it 'should return true' do
        expect(myself.change_username('HanSolo')).to eq(true)
      end

      it 'should change the username' do
        myself.change_username('HanSolo')
        expect(myself.reload.username).to eq('HanSolo')
      end
    end
  end

  describe 'new' do

    subject { Fabricate.build(:user) }

    it { is_expected.to be_valid }
    it { is_expected.not_to be_admin }

    it 'downcases email addresses' do
      user = Fabricate.build(:user, email: 'Fancy.Caps.4.U@gmail.com')
      user.save
      expect(user.reload.email).to eq('fancy.caps.4.u@gmail.com')
    end
  end

  describe 'username format' do
    it 'should be 2 chars or longer' do
      @user = Fabricate.build(:user)
      @user.username = 's'
      expect(@user.save).to eq(false)
    end

    it 'should never end with a .' do
      @user = Fabricate.build(:user)
      @user.username = 'sam.'
      expect(@user.save).to eq(false)
    end

    it 'should never contain spaces' do
      @user = Fabricate.build(:user)
      @user.username = 'sam s'
      expect(@user.save).to eq(false)
    end

    ['Bad One', 'Giraf%fe', 'Hello!', '@twitter', 'me@example.com', 'no.dots', 'purple.', '.bilbo', '_nope', 'sa$sy'].each do |bad_nickname|
      it "should not allow username '#{bad_nickname}'" do
        @user = Fabricate.build(:user)
        @user.username = bad_nickname
        expect(@user.save).to eq(false)
      end
    end
  end

  describe 'username uniqueness' do
    before do
      @user = Fabricate.build(:user)
      @user.save!
      @erick = Fabricate.build(:erick)
    end

    it 'should not allow saving if username is reused' do
      @erick.username = @user.username
      expect(@erick.save).to eq(false)
    end

    it 'should not allow saving if username is reused in different casing' do
      @erick.username = @user.username.upcase
      expect(@erick.save).to eq(false)
    end
  end

  describe '.username_available?' do
    it 'returns true for a username that is available' do
      expect(User.username_available?('BruceWayne')).to eq(true)
    end

    context 'returns false when a username is taken' do
      before { @user = Fabricate(:user) }
      it { expect(User.username_available?(@user.username)).to eq(false) }
    end
  end

  describe 'email_validator' do
    it 'should allow good emails' do
      user = Fabricate.build(:user, email: 'good@gmail.com')
      expect(user).to be_valid
    end

  end

  describe 'passwords' do
    before do
      @user = Fabricate.build(:user, active: false)
      @user.password = 'ilovepasta'
      @user.save!
    end

    it 'should have a valid password after the initial save' do
      expect(@user.authenticate!('ilovepasta')).to eq(true)
    end

    it 'should not have an active account after initial save' do
      expect(@user.active).to eq(true)
    end
  end

  describe 'last_seen_at' do
    let(:user) { Fabricate(:user) }

    it 'should have a blank last seen on creation' do
      expect(user.last_seen_at).to eq(nil)
    end

    describe 'with no previous values' do
      let!(:date) { Time.zone.now }

      before do
        Timecop.freeze(date)
        user.update_last_seen!
      end

      after do
        Timecop.return
      end

      it 'updates last_seen_at' do
        expect(user.last_seen_at).to be_within(1.second).of(date)
      end

    end
  end

  describe 'find helpers' do
    before :all do
      @bob = Fabricate(:user, username: 'bob', email: 'bob@example.com')
    end
    after :all do
      @bob.destroy
    end
    context '.find_by_email' do
      it 'same email but with different capital and small letter' do
        found_user = User.find_by_email('bob')
        expect(found_user).to be_nil

        found_user = User.find_by_email('bob@Example.com')
        expect(found_user).to eq @bob

        found_user = User.find_by_email('BOB@Example.com')
        expect(found_user).to eq @bob
      end
    end
    context '.find_by_username' do
      it 'same username but with different capital and small letter' do
        found_user = User.find_by_username('bOb')
        expect(found_user).to eq @bob
      end
    end
    context '.find_by_username_or_email' do
      it 'same username or email but with different capital and small letter' do
        found_user = User.find_by_username_or_email('Bob')
        expect(found_user).to eq @bob

        found_user = User.find_by_username_or_email('bob@Example.com')
        expect(found_user).to eq @bob

        found_user = User.find_by_username_or_email('Bob@Example.com')
        expect(found_user).to eq @bob

        found_user = User.find_by_username_or_email('bob1')
        expect(found_user).to be_nil
      end
    end
  end

  describe "secure digests" do
    describe '#new_token' do
      subject { User.new_token }
      it { should match(/\S+/) }
      it 'length should be 22' do
        expect(subject.length).to be 22
      end
    end

    describe '#digest' do
      subject { User.digest(User.new_token) }
      it { should match(/\S+/) }
      it 'length should be 60' do
        expect(subject.length).to be 60
      end
    end

    describe '.hash_password' do
      let(:too_long) { 'x' * (User.max_password_length + 1) }

      def hash(password, salt)
        User.new.send(:hash_password, password, salt)
      end

      it 'returns the same hash for the same password and salt' do
        expect(hash('poutine', 'gravy')).to eq(hash('poutine', 'gravy'))
      end

      it 'returns a different hash for the same salt and different password' do
        expect(hash('poutine', 'gravy')).not_to eq(hash('fries', 'gravy'))
      end

      it 'returns a different hash for the same password and different salt' do
        expect(hash('poutine', 'gravy')).not_to eq(hash('poutine', 'cheese'))
      end

      it 'raises an error when passwords are too long' do
        expect { hash(too_long, 'gravy') }.to raise_error
      end

    end

  end
end
