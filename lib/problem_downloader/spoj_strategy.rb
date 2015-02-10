require 'open-uri'
require 'nokogiri'

class ProblemDownloader::SPOJStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "SPOJ,#{@id}",
      default_time_limit: @time_limit[1].to_i * 1000,  # TODO: Ignored the maximum time if minimum time exist
      default_memory_limit: @memory_limit[1].to_i * 1024
    }
    params
  end

  def download(context)
    url = "http://www.spoj.com/problems/#{context.problem_index}"
    begin
      html = Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError
      return false
    end
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('no such problem')

    @id = context.problem_index
    @raw_content = ''

    fragment = Nokogiri::HTML.fragment(/<p align="justify">[\s]*<\/p>[\s]*<p>([\s\S]*?)<\/p>[\s]*<h3>Input<\/h3>/u.match(raw)[1].gsub("</p>", "\n"))
    @raw_content << "## Description\n" << fragment.text.strip.gsub("\r\n", '').gsub(/\s+$/, "\n") << "\n"
    fragment.search('img').each do |img|
      img_html = img.to_html
      @raw_content << img_html.gsub(/src="..\/../, 'src="http://www.spoj.com') << "\n"
    end
    @raw_content << "\n"

    fragment = Nokogiri::HTML.fragment(/<h3>Input<\/h3>[\s]*<p>([\s\S]*?)<\/p>[\s]*<h3>Output<\/h3>/u.match(raw)[1].gsub("</p>", "\n"))
    @raw_content << "## Input\n" << fragment.text.strip.gsub("\r\n", '').gsub(/\s+$/, "\n") << "\n"
    fragment.search('img').each do |img|
      img_html = img.to_html
      @raw_content << img_html.gsub(/src="..\/../, 'src="http://www.spoj.com') << "\n"
    end
    @raw_content << "\n"

    fragment = Nokogiri::HTML.fragment(/<h3>Output<\/h3>([\s\S]*?)<\/p>[\s]*<h3>Example<\/h3>/u.match(raw)[1].gsub("</p>", "\n"))
    @raw_content << "## Output\n" << fragment.text.strip.gsub("\r\n", '').gsub(/\s+$/, "\n") << "\n"
    fragment.search('img').each do |img|
      img_html = img.to_html
      @raw_content << img_html.gsub(/src="..\/../, 'src="http://www.spoj.com') << "\n"
    end
    @raw_content << "\n"

    fragment = Nokogiri::HTML.fragment(/<pre>[\s]*<b>Input:<\/b>([\s\S]*?)<b>Output:<\/b>/u.match(raw)[1])
    @raw_content << "## Sample Input\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

    fragment = Nokogiri::HTML.fragment(/<b>Output:<\/b>([\s\S]*?)<\/pre>/u.match(raw)[1])
    @raw_content << "## Sample Output\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

    fragment = Nokogiri::HTML.fragment(/<b>Output:<\/b>[\s\S]*?<\/pre>([\s\S]*?)<hr>[\s]*<table border="0"/u.match(raw)[1].gsub("<h3>", '### ').gsub("</h3>", "\n").gsub("</p>", "\n"))
    @raw_content << "## Note\n" << fragment.text.strip.gsub("\r\n", '').gsub(/\s+$/, "\n") << "\n"
    fragment.search('img').each do |img|
      img_html = img.to_html
      @raw_content << img_html.gsub(/src="..\/../, 'src="http://www.spoj.com') << "\n"
    end
    @raw_content << "\n"

    fragment = Nokogiri::HTML.fragment(/<td>Added by:<\/td>[\s]*<td>([\s\S]*?)<\/td>[\s]*<\/tr>/u.match(raw)[1])
    @raw_content << "## Added by\n" << fragment.text.strip.gsub("\r\n", '').gsub(/\s+$/, "\n") << "\n\n"

    fragment = Nokogiri::HTML.fragment(/<td>Date:<\/td>[\s]*<td>([\s\S]*?)<\/td>[\s]*<\/tr>/u.match(raw)[1])
    @raw_content << "## Date\n" << fragment.text.strip.gsub("\r\n", '').gsub(/\s+$/, "\n") << "\n\n"

    fragment = Nokogiri::HTML.fragment(/<td>Resource:<\/td>[\s]*<td>([\s\S]*?)<\/td>[\s]*<\/tr>/u.match(raw)[1])
    @raw_content << "## Resource\n" << fragment.text.strip.gsub("\r\n", '').gsub(/\s+$/, "\n") << "\n\n"

    @title = /<h1>\d+[.] ([\s\S]*?)<\/h1>/.match(raw)[1].strip
    @time_limit = /<td>Time limit:<\/td>[\s]*<td>([\s\S]*?)s(-([\s\S]*?)s)?<\/td>/i.match(raw)
    @memory_limit = /<td>Memory limit:<\/td>[\s]*<td>([\s\S]*?)MB<\/td>/i.match(raw)
    @raw_content << "## Remote Url\n" << "[SPOJ #{@id}: #{@title}](#{url})\n"
    html
  end
end
