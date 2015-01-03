module Searchable
  extend ActiveSupport::Concern

  included do
    after_save :update_index
  end

  class_methods do

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

    def self.scrub_html_for_search(html)
      HtmlScrubber.scrub(html)
    end

    def self.update_search_index(record, raw_search_data, stemmer = Search.long_locale)
      search_data = Search.prepare_data(raw_search_data)

      table_name = record.model_name.singular
      search_data_table_name = "#{table_name}_search_data"
      foreign_key = "#{table}_id"

      connection = ActiveRecord::Base.connection
      connection.execute("
          UPDATE #{search_data_table_name}
          SET
            raw_data = :search_data,
            search_data = TO_TSVECTOR('#{stemmer}', :search_data)
          WHERE #{foreign_key} = :id
        ", search_data: search_data, id: id)

      # will take no effect if they conflict
      connection.execute("
          INSERT INTO #{search_data_table_name}
          (#{foreign_key}, search_data, raw_data)
          VALUES (:id, TO_TSVECTOR('#{stemmer}', :search_data), :search_data)
          WHERE #{foreign_key} = :id
        ", search_data: search_data, id: id)
    rescue
      # don't allow concurrency to mess up saving an index
    end
  end
end

