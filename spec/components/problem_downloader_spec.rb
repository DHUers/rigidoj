require 'spec_helper'

describe ProblemDownloader do
  let(:available_judge_strategies) { %w(hdu poj uva uva_live zoj) }
  it 'initialze' do
    available_judge_strategies.each do |name|
      expect { ProblemDownloader.new(name, 0) }.not_to raise_error
    end
  end

  it 'raises error when online judge strategy is not available' do
    %w(a b).each do |name|
      expect { ProblemDownloader.new(name, 0) }.to raise_error(ProblemDownloader::NoDownloadStrategy)
    end
  end
end
