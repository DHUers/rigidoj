class ProblemDownloader
  class NoDownloadStrategy < Exception; end

  attr_reader :problem_index

  def initialize(oj_name, problem_index, opts={})
    @oj_name = oj_name.downcase.to_sym
    @problem_index = problem_index.to_i
    @downloader = nil
    @opts = opts || {}

    set_downloader_strategy
  end

  def download_and_create_problem
    download ? Problem.new(problem_params) : nil
  end

  private

  def problem_params
    @downloader.problem_params.merge(judge_type: :remote_proxy)
  end

  def download
    @downloader.download(self)
  end

  def set_downloader_strategy
    case @oj_name
    when :hdu then @downloader = HDUStrategy.new
    when :poj then @downloader = POJStrategy.new
    when :uva then @downloader = UVAStrategy.new
    when :uva_live then @downloader = UVALiveStrategy.new
    when :zoj then @downloader = ZOJStrategy.new
    else raise NoDownloadStrategy
    end
  end
end
