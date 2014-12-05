require 'spec_helper'

describe User do

  it { should validate_presence_of :username }
  it { should validate_presence_of :email }

  describe 'change_username' do
    let(:user) { Fabricate(:user) }

    context 'success' do
      let(:new_username) { "#{user.username}1" }

      before do
        @result = user.change_username(new_username)
      end

      it 'returns true' do
        @result.should == true
      end

      it 'should change the username' do
        user.reload
        user.username.should == new_username
      end

      it 'should change the username_lower' do
        user.reload
        user.username_lower.should == new_username.downcase
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
        @result.should == false
      end

      it 'should not change the username' do
        user.reload
        user.username.should == username_before_change
      end

      it 'should not change the username_lower' do
        user.reload
        user.username_lower.should == username_lower_before_change
      end
    end

    describe 'change the case of my username' do
      let!(:myself) { Fabricate(:user, username: 'hansolo') }

      it 'should return true' do
        myself.change_username('HanSolo').should == true
      end

      it 'should change the username' do
        myself.change_username('HanSolo')
        myself.reload.username.should == 'HanSolo'
      end
    end
  end

  describe 'new' do

    subject { Fabricate.build(:user) }

    it { should be_valid }
    it { should_not be_admin }

    it 'downcases email addresses' do
      user = Fabricate.build(:user, email: 'Fancy.Caps.4.U@gmail.com')
      user.save
      user.reload.email.should == 'fancy.caps.4.u@gmail.com'
    end
  end

  describe 'username format' do
    it "should be 3 chars or longer" do
      @user = Fabricate.build(:user)
      @user.username = 'ss'
      @user.save.should == false
    end

    it 'should never end with a .' do
      @user = Fabricate.build(:user)
      @user.username = 'sam.'
      @user.save.should == false
    end

    it 'should never contain spaces' do
      @user = Fabricate.build(:user)
      @user.username = 'sam s'
      @user.save.should == false
    end

    ['Bad One', 'Giraf%fe', 'Hello!', '@twitter', 'me@example.com', 'no.dots', 'purple.', '.bilbo', '_nope', 'sa$sy'].each do |bad_nickname|
      it "should not allow username '#{bad_nickname}'" do
        @user = Fabricate.build(:user)
        @user.username = bad_nickname
        @user.save.should == false
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
      @erick.save.should == false
    end

    it 'should not allow saving if username is reused in different casing' do
      @erick.username = @user.username.upcase
      @erick.save.should == false
    end
  end

  context '.username_available?' do
    it 'returns true for a username that is available' do
      User.username_available?('BruceWayne').should == true
    end

    it 'returns false when a username is taken' do
      User.username_available?(Fabricate(:user).username).should == false
    end
  end

  describe 'email_validator' do
    it 'should allow good emails' do
      user = Fabricate.build(:user, email: 'good@gmail.com')
      user.should be_valid
    end

  end

  describe 'passwords' do
    before do
      @user = Fabricate.build(:user, active: false)
      @user.password = 'ilovepasta'
      @user.save!
    end

    it 'should have a valid password after the initial save' do
      @user.authenticate!('ilovepasta').should == true
    end

    it 'should not have an active account after initial save' do
      @user.active.should == false
    end
  end

  describe "previous_visit_at" do

    let(:user) { Fabricate(:user) }
    let!(:first_visit_date) { Time.zone.now }
    let!(:second_visit_date) { 2.hours.from_now }
    let!(:third_visit_date) { 5.hours.from_now }

    before do
      SiteSetting.stubs(:active_user_rate_limit_secs).returns(0)
      SiteSetting.stubs(:previous_visit_timeout_hours).returns(1)
    end

    it "should act correctly" do
      user.previous_visit_at.should == nil

      # first visit
      user.update_last_seen!(first_visit_date)
      user.previous_visit_at.should == nil

      # updated same time
      user.update_last_seen!(first_visit_date)
      user.reload
      user.previous_visit_at.should == nil

      # second visit
      user.update_last_seen!(second_visit_date)
      user.reload
      user.previous_visit_at.should be_within_one_second_of(first_visit_date)

      # third visit
      user.update_last_seen!(third_visit_date)
      user.reload
      user.previous_visit_at.should be_within_one_second_of(second_visit_date)
    end

  end

  describe 'last_seen_at' do
    let(:user) { Fabricate(:user) }

    it 'should have a blank last seen on creation' do
      user.last_seen_at.should == nil
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
        user.last_seen_at.should be_within_one_second_of(date)
      end

    end
  end

  describe '.find_by_username_or_email' do
    it 'finds users' do
      bob = Fabricate(:user, username: 'bob', email: 'bob@example.com')
      found_user = User.find_by_username_or_email('Bob')
      expect(found_user).to eq bob

      found_user = User.find_by_username_or_email('bob@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_username_or_email('Bob@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_username_or_email('bob1')
      expect(found_user).to be_nil

      found_user = User.find_by_email('bob@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_email('BOB@Example.com')
      expect(found_user).to eq bob

      found_user = User.find_by_email('bob')
      expect(found_user).to be_nil

      found_user = User.find_by_username('bOb')
      expect(found_user).to eq bob
    end

  end

  describe "hash_passwords" do
    let(:too_long) { "x" * (User.max_password_length + 1) }

    def hash(password, salt)
      User.new.send(:hash_password, password, salt)
    end

    it 'returns the same hash for the same password and salt' do
      hash('poutine', 'gravy').should == hash('poutine', 'gravy')
    end

    it 'returns a different hash for the same salt and different password' do
      hash('poutine', 'gravy').should_not == hash('fries', 'gravy')
    end

    it 'returns a different hash for the same password and different salt' do
      hash('poutine', 'gravy').should_not == hash('poutine', 'cheese')
    end

    it 'raises an error when passwords are too long' do
      -> { hash(too_long, 'gravy') }.should raise_error
    end

  end

end
