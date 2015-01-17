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

  describe 'ProblemDownloader::HDUStrategy downloads problem' do
    before do
      fake('http://acm.hdu.edu.cn/showproblem.php?pid=0', external_oj_response('hdu_not_exists'))
      fake('http://acm.hdu.edu.cn/showproblem.php?pid=1025', external_oj_response('hdu_normal'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.new('hdu', 0).download_and_create_problem
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.new('hdu', 1025).download_and_create_problem
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end
  end
end
