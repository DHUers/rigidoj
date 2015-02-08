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
    
      fragment = Nokogiri::HTML.fragment(/<b>Note<\/b><\/div>([\s\S]*?)<br><br><\/div><hr>/s.match(raw)[1])
      @raw_content << "## Hint\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment.text.empty?
    else
      if raw.include?("<title>Saratov State University")
        # info.description = (Tools.regFind(html, "output:\\s*standard[\\s\\S]*?</div><br><br><br>([\\s\\S]*?)<div align = left><br><b>Input</b>"));
        # info.input = (Tools.regFind(html, "<b>Input</b></div>([\\s\\S]*?)<div align = left><br><b>Output</b>"));
        # info.input = (Tools.regFind(html, "<b>Output</b></div>([\\s\\S]*?)<div align = left><br><b>Sample test"));
        # info.sampleInput = (Tools.regFind(html, "<b>Sample test\\(s\\)</b></div>([\\s\\S]*?)(<div align = left><br><b>Note</b>|<div align = right>)"));
        # info.hint = (Tools.regFind(html, "<b>Note</b></div>([\\s\\S]*?)<div align = right>"));
      end
    end

    fragment = Nokogiri::HTML.fragment(/Resource:<\/td><td>([\s\S]*?)\n<\/td>/s.match(raw)[1])
    @raw_content << "## Source\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless fragment.text.empty?

    @title = /#{@id}[.] ([\s\S]*?)</.match(raw)[1].strip
    @time_limit = /Time limit( per test)?: ([\d\.]*)/i.match(raw)
    @memory_limit = /Memory limit( per test)?: ([\d]*)/i.match(raw)
    @raw_content << "## Remote Url\n" << "[SGU #{@id}: #{@title}](#{url})\n"
    html
  end
end
