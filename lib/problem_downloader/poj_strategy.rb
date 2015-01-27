require 'open-uri'
require 'nokogiri'

class ProblemDownloader::POJStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "POJ,#{@id}",
      default_time_limit: @time_limit[1],
      default_memory_limit: @memory_limit[1]
    }
    params
  end

  def download(context)
    params = {
      id: context.problem_index
    }
    url = "http://poj.org/problem?#{params.to_query}"
    html = Nokogiri::HTML.fragment(open(url).read.gsub('class="sio"', 'class="ptx"').gsub('<=', '&lt;=').gsub('>=', '&gt;='))
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('Can not find problem') or raw.include?('Error Occurred')

    @id = context.problem_index
    @raw_content = ''
    html = Nokogiri::HTML.fragment(raw)

    html.css('.pst').zip(html.css('.ptx')).each do |title, content|
      title = title.text.strip
      case title
      when 'Description', 'Input', 'Output', 'Hint'
        content.css('br').each { |br| br.replace("\n") }
        @raw_content << "## #{title}\n" << content.text.strip.gsub(/\s+$/, "\n")
        content.search('img').each do |img|
          img_html = img.to_html
          @raw_content << "\n\n" << img_html.gsub(/src="/, 'src="http://poj.org/')
        end
        @raw_content << "\n\n"
      when 'Sample Input', 'Sample Output'
        @raw_content << "## #{title}\n" << content.text.strip.gsub(/^(\S)/, '    \1').gsub(/\r\n|\r|\n/, "\n") << "\n\n"
      else
        @raw_content << "## #{title}\n" << content.text.strip.gsub(/\s+$/, "\n") << "\n\n" unless content.text.empty?
      end
    end
    @title = html.css('.ptt')[0].content
    @time_limit = /Time Limit:<\/b> (\d*)/i.match(raw)
    @memory_limit = /Memory Limit:<\/b> (\d*)/i.match(raw)
    @raw_content << "## Remote Url\n" << "[POJ #{@id}: #{@title}](#{url})\n"
    html
  end
end
