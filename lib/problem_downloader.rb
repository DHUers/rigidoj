class ProblemDownloader
  AVAILABLE_STRATEGIES = [
      ['hdu', HDUStrategy],
      ['poj', POJStrategy],
      ['uva', UVAStrategy],
      ['uva_live', UVALiveStrategy],
      ['zoj', ZOJStrategy]
  ]
  AVAILABLE_STRATEGIES_LIST = AVAILABLE_STRATEGIES.map {|s| [s.first, s.first]}

  class NoDownloadStrategy < Exception; end

  attr_reader :problem_index

  def initialize(oj_name, problem_index, opts={})
    @oj_name = oj_name.downcase.to_s
    @problem_index = problem_index.to_i
    @downloader = nil
    @opts = opts || {}

    set_downloader_strategy
  end

  def self.download_and_create_problem(oj_name, problem_index, opts={})
    downloader = new(oj_name, problem_index, opts)
    downloader.download ? Problem.new(downloader.problem_params) : nil
  end

  def download
    @downloader.download(self)
  end

  def problem_params
    @downloader.problem_params.merge(judge_type: :remote_proxy)
  end

  private

  def set_downloader_strategy
    strategy = AVAILABLE_STRATEGIES.select {|s| s.first === @oj_name}.flatten
    if strategy.any?
      @downloader = strategy.last.new
    else
      raise NoDownloadStrategy
    end
  end
end
