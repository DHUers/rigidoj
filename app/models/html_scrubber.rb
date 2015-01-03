class HtmlScrubber < Nokogiri::XML::SAX::Document
  attr_reader :scrubbed

  def initialize
    @scrubbed = ""
  end

  def self.scrub(html)
    me = new
    parser = Nokogiri::HTML::SAX::Parser.new(me)
    begin
      copy = "<div>"
      copy << html unless html.nil?
      copy << "</div>"
      parser.parse(html) unless html.nil?
    end
    me.scrubbed
  end

  def start_element(name, attributes=[])
    attributes = Hash[*attributes.flatten]
    if attributes["alt"]
      scrubbed << " "
      scrubbed << attributes["alt"]
      scrubbed << " "
    end
    if attributes["title"]
      scrubbed << " "
      scrubbed << attributes["title"]
      scrubbed << " "
    end
  end

  def characters(string)
    scrubbed << " "
    scrubbed << string
    scrubbed << " "
  end
end
