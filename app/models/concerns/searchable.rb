module Searchable
  extend ActiveSupport::Concern

  included do
    require 'html_scrubber'

    after_save :update_index
  end

  class_methods do
    def scrub_html_for_search(html)
      HtmlScrubber.scrub(html)
    end

    def update_search_index(table_name, id, raw_search_data, stemmer = Search.long_locale)
      search_data = Search.prepare_data(raw_search_data)

      search_data_table_name = "#{table_name}_search_data"
      foreign_key = "#{table_name}_id"

      rows = Post.exec_sql_row_count("
          UPDATE #{search_data_table_name}
          SET
            raw_data = :search_data,
            search_data = TO_TSVECTOR('#{stemmer}', :search_data)
          WHERE #{foreign_key} = :id
        ", search_data: search_data, id: id)

      # will take no effect if they conflict
      if rows == 0
        Post.exec_sql_row_count("
            INSERT INTO #{search_data_table_name}
            (#{foreign_key}, search_data, raw_data)
            VALUES (:id, TO_TSVECTOR('#{stemmer}', :search_data), :search_data)
          ", search_data: search_data, id: id)
      end
    end
  end
end

