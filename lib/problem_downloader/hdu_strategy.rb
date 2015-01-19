require 'open-uri'
require 'nokogiri'

class ProblemDownloader::HDUStrategy
  def problem_params
    params = {
        title: @title,
        raw: @raw_content,
        remote_proxy_vendor: "HDU,#{@id}",
        default_time_limit: @time_limit[2],
        default_memory_limit: @memory_limit[2]
    }
    params
  end

  def download(context)
    params = {
        pid: context.problem_index
    }
    url = "http://acm.hdu.edu.cn/showproblem.php?#{params.to_query}"
    html = Nokogiri::HTML(open(url))
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('No such problem') or raw.include?('Invalid Parameter')

    @id = context.problem_index
    @raw_content = ''
    html.css('.panel_title').zip(html.search('.panel_content')).each do |title, content|
      title = title.text.strip
      case title
      when 'Problem Description'
        content.css('br').each { |br| br.replace("\n") }
        @raw_content << "## Description\n" << content.text.strip.gsub(/\s+$/, "\n") << "\n\n"
      when 'Sample Input', 'Sample Output'
        @raw_content << "## #{title}\n" << content.text.strip.gsub(/^(\S)/, '    \1').gsub(/\r\n|\r|\n/, "\n") << "\n\n"
      else
        @raw_content << "## #{title}\n" << content.text.strip << "\n\n" unless content.text.empty?
      end
    end
    @title = html.css('h1')[0].content
    @time_limit = /Time Limit: (\d*)\/(\d*)/i.match(raw)
    @memory_limit = /Memory Limit: (\d*)\/(\d*)/i.match(raw)
    @raw_content << "\n\n## Remote Url" << "[HDU #{@id}: #{@title}](#{url})"
    html
  end

  private

  def content_to_makedown(raw)
    raw = raw.sub(/(\S)input\n/i, "\\1\n\n## Input\n")
    raw = raw.sub(/(\S)output\n/i, "\\1\n\n## Output\n")
    raw = raw.sub(/sample input\n/i, "\n\n## Sample Input\n```\n")
    raw = raw.sub(/sample output\n/i, "\n```\n\n## Sample Output\n```\n")
    raw = raw.sub(/source\n/i, "\n\n## Source\n")
    raw = raw.sub(/author\n/i, "\n\n## Author\n")
    raw = raw.sub(/recommend\n/i, "\n\n## Recommend\n")
    raw = raw.gsub(/\s+$/, "\n")
    #raw = raw.gsub(/## Sample Input\n(.*)\n\n##/, "## Sample Input\n```\\1```\n\n##")
    #raw.gsub(/## Sample Output\n(.*)\n\n##/, "## Sample Output\n```\\1```\n\n##")
  end
end
