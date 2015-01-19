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
        @raw_content << "## Description\n" << content.text.strip.gsub(/\s+$/, "\n")
        content.search('img').each do |img|
          img_html = img.to_html
          @raw_content << "\n\n" << img_html.gsub(/src="/, 'src="http://acm.hdu.edu.cn')
        end
        @raw_content << "\n\n"
      when 'Sample Input', 'Sample Output'
        @raw_content << "## #{title}\n" << content.text.strip.gsub(/^(\S)/, '    \1').gsub(/\r\n|\r|\n/, "\n") << "\n\n"
      else
        @raw_content << "## #{title}\n" << content.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless content.text.empty?
      end
    end
    @title = html.css('h1')[0].content
    @time_limit = /Time Limit: (\d*)\/(\d*)/i.match(raw)
    @memory_limit = /Memory Limit: (\d*)\/(\d*)/i.match(raw)
    @raw_content << "## Remote Url\n\n" << "[HDU #{@id}: #{@title}](#{url})\n"
    html
  end
end
