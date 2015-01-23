require 'spec_helper'

describe Notification do
  it { is_expected.to validate_presence_of :notification_type }
  it { is_expected.to validate_presence_of :data }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :problem }
  it { is_expected.to belong_to :solution }
  it { is_expected.to belong_to :contest }

end
