require 'spec_helper'

describe ProblemDownloader do
  let(:available_judge_strategies) { %w(hdu poj uva uva_live zoj sgu) }
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
      problem = ProblemDownloader.download_and_create_problem('hdu', 0)
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('hdu', 1025)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('hdu', 1025)
      expect(problem.raw).to eq parsed_markdown('hdu_1025')
    end
  end

  describe 'ProblemDownloader::ZOJStrategy downloads problem' do
    before do
      fake('http://acm.zju.edu.cn/onlinejudge/showProblem.do?problemCode=0', external_oj_response('zoj_not_exists'))
      fake('http://acm.zju.edu.cn/onlinejudge/showProblem.do?problemCode=3814', external_oj_response('zoj_normal'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('zoj', 0)
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('zoj', 3814)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('zoj', 3814)
      expect(problem.title).to eq 'Sawtooth Puzzle'
      expect(problem.raw).to eq parsed_markdown('zoj_3814')
    end
  end

  describe 'ProblemDownloader::POJStrategy downloads problem' do
    before do
      fake('http://poj.org/problem?id=0', external_oj_response('poj_not_exists'))
      fake('http://poj.org/problem?id=1095', external_oj_response('poj_normal'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('poj', 0)
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('poj', 1095)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('poj', 1095)
      expect(problem.title).to eq 'Trees Made to Order'
      expect(problem.raw).to eq parsed_markdown('poj_1095')
    end
  end

  describe 'ProblemDownloader::SGUStrategy downloads problem' do
    before do
      fake('http://acm.sgu.ru/problem.php?problem=0', external_oj_response('sgu_not_exists'))
      fake('http://acm.sgu.ru/problem.php?problem=493', external_oj_response('sgu_normal'))
      fake('http://acm.sgu.ru/problem.php?problem=264', external_oj_response('sgu_normal_1'))
      fake('http://acm.sgu.ru/problem.php?problem=143', external_oj_response('sgu_normal_2'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('sgu', 0)
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('sgu', 493)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
      problem = ProblemDownloader.download_and_create_problem('sgu', 264)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
      problem = ProblemDownloader.download_and_create_problem('sgu', 143)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('sgu', 493)
      expect(problem.title).to eq 'Illumination of Buildings'
      expect(problem.raw).to eq parsed_markdown('sgu_493')
      problem = ProblemDownloader.download_and_create_problem('sgu', 264)
      expect(problem.title).to eq 'Travel'
      expect(problem.raw).to eq parsed_markdown('sgu_264')
      problem = ProblemDownloader.download_and_create_problem('sgu', 143)
      expect(problem.title).to eq 'Long Live the Queen'
      expect(problem.raw).to eq parsed_markdown('sgu_143')
    end
  end

  describe 'ProblemDownloader::SPOJStrategy downloads problem' do
    before do
      fake('http://www.spoj.com/problems/0', external_oj_response('spoj_not_exists'), 404)
      fake('http://www.spoj.com/problems/SEQPAR2', external_oj_response('spoj_normal'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('spoj', '0')
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('spoj', 'SEQPAR2')
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('spoj', 'SEQPAR2')
      expect(problem.title).to eq 'Sequence Partitioning II'
      expect(problem.raw).to eq parsed_markdown('spoj_SEQPAR2')
    end
  end

  describe 'ProblemDownloader::UralStrategy downloads problem' do
    before do
      fake('http://acm.timus.ru/print.aspx?space=1&num=0', external_oj_response('ural_not_exists'))
      fake('http://acm.timus.ru/print.aspx?space=1&num=2032', external_oj_response('ural_normal'))
      fake('http://acm.timus.ru/print.aspx?space=1&num=1050', external_oj_response('ural_normal_1'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('ural', 0)
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('ural', 2032)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
      problem = ProblemDownloader.download_and_create_problem('ural', 1050)
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('ural', 2032)
      expect(problem.title).to eq 'Conspiracy Theory and Rebranding'
      expect(problem.raw).to eq parsed_markdown('ural_2032')
      problem = ProblemDownloader.download_and_create_problem('ural', 1050)
      expect(problem.title).to eq 'Preparing an Article'
      expect(problem.raw).to eq parsed_markdown('ural_1050')
    end
  end

  describe 'ProblemDownloader::AIZUStrategy downloads problem' do
    before do
      fake('http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0', external_oj_response('aizu_not_exists'), 500)
      fake('http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=1303', external_oj_response('aizu_normal'))
      fake('http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2303', external_oj_response('aizu_normal_1'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('aizu', '0')
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('aizu', '1303')
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
      problem = ProblemDownloader.download_and_create_problem('aizu', '2303')
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('aizu', '1303')
      expect(problem.title).to eq 'Hobby on Rails'
      expect(problem.raw).to eq parsed_markdown('aizu_1303')
      problem = ProblemDownloader.download_and_create_problem('aizu', '2303')
      expect(problem.title).to eq 'Marathon Match'
      expect(problem.raw).to eq parsed_markdown('aizu_2303')
    end
  end

  describe 'ProblemDownloader::CodeforcesStrategy downloads problem' do
    before do
      fake('http://codeforces.com/problemset/problem/0/A', external_oj_response('codeforces_not_exists'))
      fake('http://codeforces.com/problemset/problem/505/B', external_oj_response('codeforces_normal'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('codeforces', '0A')
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('codeforces', '505B')
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('codeforces', '505B')
      expect(problem.title).to eq "Mr. Kitayuta's Colorful Graph"
      expect(problem.raw).to eq parsed_markdown('codeforces_505B')
    end
  end

  describe 'ProblemDownloader::CodeforcesGymStrategy downloads problem' do
    before do
      fake('http://codeforces.com/gym/0/problem/A', external_oj_response('codeforces_gym_not_exists'))
      fake('http://codeforces.com/gym/100571/problem/D', external_oj_response('codeforces_gym_normal'))
    end

    it 'create nil when the problem is not exists' do
      problem = ProblemDownloader.download_and_create_problem('codeforces_gym', '0A')
      expect(problem).to be_nil
    end

    it 'downloads and creates valid problem' do
      problem = ProblemDownloader.download_and_create_problem('codeforces_gym', '100571D')
      expect(problem).not_to be_nil
      expect(problem.valid?).to be_truthy
    end

    it 'should parsed accordingly' do
      problem = ProblemDownloader.download_and_create_problem('codeforces_gym', '100571D')
      expect(problem.title).to eq "ShortestPath Query"
      expect(problem.raw).to eq parsed_markdown('codeforces_gym_100571D')
    end
  end
end
