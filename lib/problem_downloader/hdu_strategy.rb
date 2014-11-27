require 'open-uri'
require 'nokogiri'

class ProblemDownloader::HDUStrategy
  def download(context)
    url = "http://acm.hdu.edu.cn/showproblem.php?pid=#{context.problem_index}"
    html = Nokogiri::HTML(open(url))
    raw = html.inner_html.encode('utf-8')

    return '' if raw.include?('No such problem') or raw.include?('Invalid Parameter')

    raw_content = ''
    html.css('.panel_title').zip(html.css('.panel_content')).each do |x,y|
      unless y.content == ''
        raw_content += <<EOF
#{x.content.gsub(/\r?\n/, '')}
#{y.content.gsub(/\r?\n/, '')}
EOF
      end
    end
    title = html.css('h1')[0].content
    time_limit = /Time Limit: (\d*)\/(\d*)/i.match(raw)
    memory_limit = /Memory Limit: (\d*)\/(\d*)/i.match(raw)

    {
        title: title,
        raw: content_to_makedown(raw_content),
        source: "<a href='#{url}' rel='nofollow'>HDU #{html.title}: #{title}</a>",
        time_limit: {
            default: time_limit[2],
            java: time_limit[1]
        },
        memory_limit: {
          default: memory_limit[2],
          java: memory_limit[1]
      }
    }
  end

  private

  def content_to_makedown(raw)
    raw = raw.gsub(/problem description\n/i, "## Description\n")
    raw = raw.gsub(/\ninput\n/i, "\n\n## Input\n")
    raw = raw.gsub(/\noutput\n/i, "\n\n## Output\n")
    raw = raw.gsub(/\nsample input\n/i, "\n\n## Sample Input\n")
    raw = raw.gsub(/\nsample output\n/i, "\n\n## Sample Output\n")
    raw = raw.gsub(/\nsource\n/i, "\n\n## Source\n")
    raw = raw.gsub(/\nauthor\n/i, "\n\n## Author\n")
    raw = raw.gsub(/\nrecommend\n/i, "\n\n## Recommend\n")
    raw = raw.gsub(/## Sample Input\n(.*)\n\n##/, "## Sample Input\n```\\1```\n\n##")
    raw.gsub(/## Sample Output\n(.*)\n\n##/, "## Sample Output\n```\\1```\n\n##")
  end
end
