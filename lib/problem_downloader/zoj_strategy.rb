require 'open-uri'
require 'nokogiri'

class ProblemDownloader::ZOJStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "ZOJ,#{@id}",
      default_time_limit: @time_limit[1].to_i * 1000,
      default_memory_limit: @memory_limit[1]
    }
    params
  end

  def download(context)
    params = {
      problemCode: context.problem_index
    }
    url = "http://acm.zju.edu.cn/onlinejudge/showProblem.do?#{params.to_query}"
    html = Nokogiri::HTML(open(url)).css('#content_body')
    raw = html.inner_html

    return false if raw.include?('No such problem.')

    @id = context.problem_index
    @raw_content = ''

    if raw.include?(">Input<") && raw.include?(">Output<") && raw.include?(">Sample Input<") && raw.include?(">Sample Output<")
      fragment = Nokogiri::HTML.fragment(/KB[\s\S]*?<\/center>[\s\S]*?<hr>([\s\S]*?)>[\s]*Input/s.match(raw)[1])
      @raw_content << "## Description\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n"
      html.search('img').each do |img|
        img_html = img.to_html
        @raw_content << img_html.gsub(/src="/, 'src="http://acm.zju.edu.cn/onlinejudge/')
      end
      @raw_content << "\n\n"

      fragment = Nokogiri::HTML.fragment(/>[\s]*Input([\s\S]*?)>[\s]*Out?put/s.match(raw)[1])
      @raw_content << "## Input\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n"

      fragment = Nokogiri::HTML.fragment(/>[\s]*Out?put([\s\S]*?)>[\s]*Sample Input/s.match(raw)[1])
      @raw_content << "## Output\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n"

      fragment = Nokogiri::HTML.fragment(/>[\s]*Sample Input([\s\S]*?)>[\s]*Sample Out?put/s.match(raw)[1])
      @raw_content << "## Sample Input\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

      fragment = Nokogiri::HTML.fragment(/>[\s]*Sample Out?put([\s\S]*?)<\/pre/s.match(raw)[1])
      @raw_content << "## Sample Output\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

      fragment = Nokogiri::HTML.fragment(/>[\s]*Hint([\s\S]*?)<hr/s.match(raw)[1])
      @raw_content << "## Hint\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment.text.empty?

      fragment = Nokogiri::HTML.fragment(/Author:\s*<strong>([\s\S]*?)<\/strong><br>/s.match(raw)[1])
      @raw_content << "## Author\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment.text.empty?

      fragment = Nokogiri::HTML.fragment(/Source:\s*<strong>([\s\S]*?)<\/strong><br>/s.match(raw)[1])
      @raw_content << "## Source\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment.text.empty?
    else
      fragment = Nokogiri::HTML.fragment(/KB[\s\S]*?<\/center>[\s\S]*?<hr>([\s\S]*?)<hr>/s.match(raw)[1])
      @raw_content << "## Description\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n"
    end

    @title = html.css('.bigProblemTitle')[0].content
    @time_limit = /Time Limit: <\/font> (\d*) Seconds/i.match(raw)
    @memory_limit = /Memory Limit: <\/font> (\d*) KB/i.match(raw)
    @raw_content << "## Remote Url\n\n" << "[ZOJ #{@id}: #{@title}](#{url})\n"
    html
  end
end
