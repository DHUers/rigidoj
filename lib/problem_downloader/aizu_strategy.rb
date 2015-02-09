require 'open-uri'
require 'nokogiri'

class ProblemDownloader::AIZUStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "AIZU,#{@id}",
      default_time_limit: @time_limit[2].to_i * 1000,
      default_memory_limit: @memory_limit[2]
    }
    params
  end

  def download(context)
    params = {
      id: context.problem_index
    }
    url = "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?#{params.to_query}"
    html = Nokogiri::HTML(open(url))
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('no such problem')

    @id = context.problem_index
    @raw_content = ''

    # TODO

    @title = /#{@id}[.] ([\s\S]*?)</.match(raw)[1].strip
    @time_limit = /Time limit( per test)?: ([\d\.]*)/i.match(raw)
    @memory_limit = /Memory limit( per test)?: ([\d]*)/i.match(raw)
    @raw_content << "## Remote Url\n" << "[AIZU #{@id}: #{@title}](#{url})\n"
    html
  end
end
