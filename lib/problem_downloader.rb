class ProblemDownloader
  attr_reader :problem_index

  def initialize(oj_name, problem_index, opts={})
    @oj_name = oj_name.to_sym
    @problem_index = problem_index.to_i
    @downloader = nil
    @opts = opts || {}

    set_downloader_strategy
  end

  def set_downloader_strategy
    case @oj_name
      when :hdu then @downloader = HDUStrategy.new
      when :poj then @downloader = POJStrategy.new
      when :uva then @downloader = UVAStrategy.new
      when :uva_live then @downloader = UVALiveStrategy.new
      when :zoj then @downloader = ZOJStrategy.new
    end
  end

  def download
    @downloader.download(self)
  end
end
