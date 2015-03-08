require 'spec_helper'

describe Problem do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :raw }
  it_behaves_like 'slugable'

  context 'slug' do
  end

end
