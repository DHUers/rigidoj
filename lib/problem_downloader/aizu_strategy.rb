require 'open-uri'
require 'nokogiri'

class ProblemDownloader::AIZUStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "AIZU,#{@id}",
      default_time_limit: @time_limit[1].to_i * 1000,
      default_memory_limit: @memory_limit[1]
    }
    params
  end

  def download(context)
    params = {
      id: context.problem_index
    }
    url = "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?#{params.to_query}"
    begin
      html = Nokogiri::HTML(open(url))
      html.encoding = 'utf-8'
    rescue OpenURI::HTTPError
      return false
    end
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('no such problem') || raw.include?('Internal Server Error')

    @id = context.problem_index
    @raw_content = ''

    content = html.css('.description').inner_html.encode('utf-8')
                  .sub(/<h1>[\s\S]*?<\/h1>\s*<p>\n/, '').gsub(/<\/h2>\n*/, '')
                  .sub(/<h2>Sample[\s\S]*?<hr>/, '## Sample')
                  .gsub(/<var>|<\/var>/, '')  # remove if support Letex
                  .gsub(' ¥lt ', '<').gsub(' ¥gt ', '>')
                  .gsub(' ¥neq ', '≠').gsub(' ¥leq ', '≤').gsub(' ¥geq ', '≥')
                  .gsub(' ¥in ', '∈').gsub(' ¥ni ', '∋')
                  .gsub(' ¥times ', '×').gsub(' ¥pm ', '±')
                  .gsub(' ¥rightarrow ', '→').gsub(' ¥leftarrow ', '←')
                  .gsub(/(?<!>)[\s]*\n(?!<)/, ' ').gsub('</p>', "\n\n").gsub(/^ */, '')
                  .gsub('<h2>', '## ').sub('Source: ', "## Source\n")

    sample = /(?=<h2>Sample)([\s\S]*?)<hr>/.match(html.inner_html.encode('utf-8'))[1].strip
                  .gsub('<h2>', '## ').gsub(/<\/h2>[\s]*<pre>/, '')
                  .gsub(/<\/pre>[\n]*/, "\n").gsub(/\r\n|\r|\n/, "\n")
                  .gsub(/^/, '    ').gsub(/^    $/, "")
                  .gsub(/^ *##/, '##').gsub(/\n\n\z/, '')

    image = ''
    html.search('img').each do |img|
      img_html = img.to_html
      image << img_html.gsub(/src="/, 'src="http://judge.u-aizu.ac.jp/onlinejudge/') << "\n\n"
    end

    fragment = Nokogiri::HTML.fragment(content)
    @raw_content << "## Description\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n"
    @raw_content = @raw_content.gsub('## Sample', image << sample).gsub(/[\s ]*\z/, "\n")

    @title = /<h1 class="title">(?:.+<\/a> -)?([\s\S]*?)<\/h1>/.match(raw)[1].strip
    @time_limit = /Time Limit : (\d+) sec/i.match(raw)
    @memory_limit = /Memory Limit : (\d+) KB/i.match(raw)
    @raw_content << "## Remote Url\n" << "[AIZU #{@id}: #{@title}](#{url})\n"
    html
  end
end
