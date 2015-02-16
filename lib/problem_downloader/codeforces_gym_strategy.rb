require 'open-uri'
require 'nokogiri'

class ProblemDownloader::CodeforcesGymStrategy
  def problem_params
    params = {
      title: @title,
      raw: @raw_content,
      remote_proxy_vendor: "Codeforces_Gym,#{@id}",
      default_time_limit: @time_limit[1].to_i * 1000,
      default_memory_limit: @memory_limit[1].to_i * 1024
    }
    params
  end

  def download(context)
    contest_id = context.problem_index.gsub(/\D.*/, '')
    problem_id = context.problem_index.gsub(/^\d*/, '')
    url = "http://codeforces.com/gym/#{contest_id}/problem/#{problem_id}"
    html = Nokogiri::HTML(open(url))
    raw = html.inner_html.encode('utf-8')

    return false if raw.include?('No such problem') || raw.include?('No such contest')

    @id = context.problem_index
    @raw_content = ''

    html.css('.header').remove
    content = html.css('.problem-statement').inner_html.encode('utf-8')
                  .gsub('</p>', "\n\n").gsub('<br>', "\n").gsub('<li>', "\n*")
                  .gsub('<div class="section-title">', '## ')
                  .gsub('<div class="title">', '### ')

    image = ''
    html.search('img.tex-graphics').each do |img|
      img_html = img.to_html
      image << img_html << "\n\n"
    end

    fragment = Nokogiri::HTML.fragment(content)
    @raw_content << "## Description\n" << fragment.text.strip.gsub(/\s+$/, "\n") << "\n\n" << image

    @title = /<div class="title">\s*#{problem_id}. ([\s\S]*?)<\/div>/.match(raw)[1].strip
    @time_limit = /<\/div>([\d\.]+) seconds?\s*<\/div>/i.match(raw)
    @memory_limit = /<\/div>(\d+) megabytes\s*<\/div>/i.match(raw)
    @raw_content << "## Remote Url\n" << "[Codeforces::Gym #{@id}: #{@title}](#{url})\n"
    html
  end
end
