require_relative 'strategies'

class ProblemDownloader
  def initialize(oj_name, problem_index, opts)
    @oj_name = oj_name.to_sym
    @problem_index = problem_index
    @opts = opts || {}

    set_downloader_strategy
  end

  def set_downloader_strategy
    case @oj_name
      when :hdu then @downloader = HDUDownloader.new
      when :poj then @downloader = POJDownloader.new
      when :uva then @downloader = UVADownloader.new
      when :uva_live then @downloader = UVALiveDownloader.new
      when :zoj then @downloader = ZOJDownloader.new
    end
  end

  def download
    @downloader.download(self)
  end
end
