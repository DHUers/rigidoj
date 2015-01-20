require 'spec_helper'

describe Problem do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :raw }
end
