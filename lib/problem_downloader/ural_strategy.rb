require 'open-uri'
require 'nokogiri'

class ProblemDownloader::UralStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "Ural,#{@id}",
      default_time_limit: @time_limit[1].to_i * 1000,
      default_memory_limit: @memory_limit[1] * 1024
    }
    params
  end

  def download(context)
    params = {
      num: context.problem_index,
      space: 1
    }
    url = "http://acm.timus.ru/print.aspx?#{params.to_query}"
    html = Nokogiri::HTML(open(url))
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('Problem not found')

    @id = context.problem_index
    @raw_content = ''

    content = html.css('#problem_text').inner_html.encode('utf-8')
                  .gsub('</div></div>', "\n\n")
                  .gsub('<br>', "\n\n").gsub(/[\s]*\r\n/, ' ')
                  .gsub('<h3 class="problem_subtitle">', '## ')
                  .gsub('<b>Problem Author: </b>', "## Author\n")
                  .gsub('<b>Problem Source: </b>', "## Source\n")
                  .gsub(/<table class="sample">[\s\S]*?<\/table>/, '')

    sample = html.css('.sample').inner_html.encode('utf-8')
                 .gsub("<tr>\n<th width=\"350\">input</th>", '')
                 .gsub('<th width="350">output</th>', '')
                 .gsub("<tr>\n<td><pre class=\"intable\">", "### Input\n")
                 .gsub("</td>\n<td><pre class=\"intable\">", "### Output\n")
                 .gsub(/<\/pre>|<\/tr>/, "\n").gsub('</td>', '')
                 .gsub(/^/, '    ').gsub(/\r\n|\r|\n/, "\n").gsub(/^    $/, "")
                 .gsub(/[\n]{3}/, "\n").gsub(/\n\n\z/, '').gsub('    ###', '###')

    image = ''
    html.search('img').each do |img|
      img_html = img.to_html
      image << img_html.gsub(/src="/, 'src="http://acm.timus.ru') << "\n\n" unless img_html.include?('mc.yandex.ru')
    end

    fragment = Nokogiri::HTML.fragment(content)
    @raw_content << "## Description\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n"
    @raw_content = @raw_content.gsub(/## Sample[s]?/, image << (@raw_content.include?('## Samples') ? '## Samples' : '## Sample') << sample)

    @title = /problem_title">\d{4}. ([\s\S]*?)<\/h2>/.match(raw)[1].strip
    @time_limit = /Time Limit: ([\d\.]*?) second/i.match(raw)
    @memory_limit = /Memory Limit: ([\d\.]*?) MB/i.match(raw)
    @raw_content << "## Remote Url\n" << "[Ural #{@id}: #{@title}](#{url.sub("/print", "/problem")})\n"
    html
  end
end
