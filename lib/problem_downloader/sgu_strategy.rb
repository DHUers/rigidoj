require 'open-uri'
require 'nokogiri'

class ProblemDownloader::SGUStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "SGU,#{@id}",
      default_time_limit: @time_limit[2].to_i * 1000,  # TODO: Maybe time limit per test.
      default_memory_limit: @memory_limit[2]  # TODO: Maybe memory limit per test.
    }
    params
  end

  def download(context)
    params = {
      problem: context.problem_index
    }
    url = "http://acm.sgu.ru/problem.php?#{params.to_query}"
    html = Nokogiri::HTML(open(url))
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('no such problem')

    @id = context.problem_index
    @raw_content = ''

    if raw.include?("<title> SSU Online Contester")
      # type #1 (SGU 277 ~ 553)
      fragment = Nokogiri::HTML.fragment(/output: standard<\/div>[\s]*<br>([\s\S]*?)<br><br><div align="left" style="margin-top:1em;"><b>Input<\/b>/u.match(raw)[1])
      fragment.css('br').each { |br| br.replace("\n") }
      @raw_content << "## Description\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n"
      fragment.search('img').each do |img|
        img_html = img.to_html
        @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
      end
      @raw_content << "\n"

      fragment = Nokogiri::HTML.fragment(/<b>Input<\/b><\/div>([\s\S]*?)<br><br><div align="left" style="margin-top:1em;"><b>Output<\/b>/u.match(raw)[1])
      fragment.css('br').each { |br| br.replace("\n") }
      @raw_content << "## Input\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n"
      fragment.search('img').each do |img|
        img_html = img.to_html
        @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
      end
      @raw_content << "\n"

      fragment = Nokogiri::HTML.fragment(/<b>Output<\/b><\/div>([\s\S]*?)<br><br><div align="left" style="margin-top:1em;"><b>Example/u.match(raw)[1])
      fragment.css('br').each { |br| br.replace("\n") }
      @raw_content << "## Output\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n"
      fragment.search('img').each do |img|
        img_html = img.to_html
        @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
      end
      @raw_content << "\n"

      fragment = Nokogiri::HTML.fragment(/<pre>sample output<\/pre>[\s]*<\/td>[\s]*<\/tr>[\s]*<tr>[\s]*<td width="400" valign="top" style="border-collapse:collapse; border: 1px black solid;">[\s]*<pre>([\s\S]*?)<\/pre>[\s]*<\/td>[\s]*<td width="400" valign="top" style="border-collapse:collapse; border: 1px black solid;">[\s]*<pre>/u.match(raw)[1])
      @raw_content << "## Sample Input\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

      fragment = Nokogiri::HTML.fragment(/(?<!input)<\/pre>[\s]*<\/td>[\s]*<td width="400" valign="top" style="border-collapse:collapse; border: 1px black solid;">[\s]*<pre>([\s\S]*?)<\/pre>[\s]*<\/td>[\s]*<\/tr>[\s]*<\/table>/u.match(raw)[1])
      @raw_content << "## Sample Output\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

      fragment = Nokogiri::HTML.fragment(/<b>Note<\/b><\/div>([\s\S]*?)<br><br><\/div><hr>/u.match(raw))
      @raw_content << "## Note\n" << fragment[1].text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment[1] == nil
    else
      if raw.include?("<title>Saratov State University")
        # type #2 (SGU 146 ~ 276)
        fragment = Nokogiri::HTML.fragment(/output: standard<\/div>[\s]*<br><br><br><div align="left">([\s\S]*?)<\/div>[\s]*<div align="left">[\s]*<br><b>Input<\/b>/u.match(raw)[1])
        fragment.css('br').each { |br| br.replace("\n") }
        @raw_content << "## Description\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n"
        fragment.search('img').each do |img|
          img_html = img.to_html
          @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
        end
        @raw_content << "\n"

        fragment = Nokogiri::HTML.fragment(/<b>Input<\/b>[\s]*<\/div>[\s]*<div align="left">([\s\S]*?)<\/div>[\s]*<div align="left">[\s]*<br><b>Output<\/b>/u.match(raw)[1])
        fragment.css('br').each { |br| br.replace("\n") }
        @raw_content << "## Input\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n"
        fragment.search('img').each do |img|
          img_html = img.to_html
          @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
        end
        @raw_content << "\n"

        fragment = Nokogiri::HTML.fragment(/<b>Output<\/b>[\s]*<\/div>[\s]*<div align="left">([\s\S]*?)<\/div>[\s]*<div align="left">[\s]*<br><b>Sample test/u.match(raw)[1])
        fragment.css('br').each { |br| br.replace("\n") }
        @raw_content << "## Output\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n"
        fragment.search('img').each do |img|
          img_html = img.to_html
          @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
        end
        @raw_content << "\n"

        fragment = Nokogiri::HTML.fragment(/<br>Input<\/div>[\s]*<div align="left"><font face="Courier New"><\/font><\/div>[\s]*<div align="left"><pre><\/pre><\/div>[\s]*<div align="left">([\s\S]*?)<\/div>[\s]*<div align="left"><\/div>[\s]*<div align="left"><\/div>[\s]*<div align="left">[\s]*<br>Output<\/div>/u.match(raw)[1])
        @raw_content << "## Sample Input\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

        fragment = Nokogiri::HTML.fragment(/<br>Output<\/div>[\s]*<div align="left"><font face="Courier New"><\/font><\/div>[\s]*<div align="left"><pre><\/pre><\/div>[\s]*<div align="left">([\s\S]*?)<\/div>[\s]*<div align="left"><\/div>/u.match(raw)[1])
        @raw_content << "## Sample Output\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

        fragment = Nokogiri::HTML.fragment(/<b>Note<\/b>[\s]*<\/div>[\s]*<div align="left">([\s\S]*?)<\/div>[\s]*<div align="left">/u.match(raw)[1])
        @raw_content << "## Note\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment == nil

        fragment = Nokogiri::HTML.fragment(/Author:<\/td>[\s]*<td>([\s\S]*?)\n<\/td>/u.match(raw)[1])
        @raw_content << "## Author\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment == nil

        fragment = Nokogiri::HTML.fragment(/Resource:<\/td>[\s]*<td>([\s\S]*?)\n<\/td>/u.match(raw)[1])
        @raw_content << "## Resource\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment == nil

        fragment = Nokogiri::HTML.fragment(/Date:<\/td>[\s]*<td>([\s\S]*?)\n<\/td>/u.match(raw)[1])
        @raw_content << "## Date\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment == nil
      else
        # type #3 (SGU 100 ~ 145)
        fragment = Nokogiri::HTML.fragment(/<p align="JUSTIFY"><\/p>[\s]*<p align="JUSTIFY">([\s\S]*?)<\/p>[\s]*<p align="JUSTIFY"><\/p>[\s]*<b><\/b><p align="JUSTIFY">Input<\/p>/u.match(raw)[1])
        fragment.css('br').each { |br| br.replace("\n") }
        @raw_content << "## Description\n" << fragment.text.strip.gsub("\r\n", ' ') << "\n"
        fragment.search('img').each do |img|
          img_html = img.to_html
          @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
        end
        @raw_content << "\n"

        fragment = Nokogiri::HTML.fragment(/<p align="JUSTIFY">Input<\/p>[\s]*<p align="JUSTIFY">([\s\S]*?)<\/p>[\s]*<p align="JUSTIFY"><\/p>[\s]*<b><\/b><p align="JUSTIFY">Output<\/p>/u.match(raw)[1])
        fragment.css('br').each { |br| br.replace("\n") }
        @raw_content << "## Input\n" << fragment.text.strip.gsub("\r\n", ' ') << "\n"
        fragment.search('img').each do |img|
          img_html = img.to_html
          @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
        end
        @raw_content << "\n"

        fragment = Nokogiri::HTML.fragment(/<p align="JUSTIFY">Output<\/p>[\s]*<p align="JUSTIFY">([\s\S]*?)<\/p>[\s]*<p align="JUSTIFY"><\/p>[\s]*<p align="JUSTIFY">Sample Input<\/p>/u.match(raw)[1])
        fragment.css('br').each { |br| br.replace("\n") }
        @raw_content << "## Output\n" << fragment.text.strip.gsub("\r\n", ' ') << "\n"
        fragment.search('img').each do |img|
          img_html = img.to_html
          @raw_content << img_html.gsub(/src="/, 'src="http://acm.sgu.ru/').gsub(/ style="[\s\S]*?"/, '') << "\n"
        end
        @raw_content << "\n"

        fragment = Nokogiri::HTML.fragment(/<p align="JUSTIFY">Sample Input<\/p>[\s]*<font face="Courier New">[\s]*<pre>([\s\S]*?)<\/pre>[\s]*<p align="JUSTIFY"><\/p>[\s]*<\/font>[\s]*<p align="JUSTIFY">Sample Output<\/p>/u.match(raw)[1])
        @raw_content << "## Sample Input\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"

        fragment = Nokogiri::HTML.fragment(/<p align="JUSTIFY">Sample Output<\/p>[\s]*<font face="Courier New">[\s]*<pre>([\s\S]*?)<\/pre>[\s]*<\/font>/u.match(raw)[1])
        @raw_content << "## Sample Output\n" << fragment.text.strip.gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "") << "\n\n"
      end
    end

    @title = /#{@id}[.] ([\s\S]*?)</.match(raw)[1].strip
    @time_limit = /Time limit( per test)?: ([\d\.]*)/i.match(raw)
    @memory_limit = /Memory limit( per test)?: ([\d]*)/i.match(raw)
    @raw_content << "## Remote Url\n" << "[SGU #{@id}: #{@title}](#{url})\n"
    html
  end
end
