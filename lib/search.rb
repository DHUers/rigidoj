module Search
  def self.per_facet
    5
  end

  def self.per_filter
    50
  end

  def self. long_locale
    case SiteSetting.default_locale.to_sym
      when :en     then 'english'
      else 'simple' # use the 'simple' stemmer for other languages
    end
  end

  def self.prepare_data(search_data)
    data = search_data.squish
    if ['zh_TW', 'zh_CN'].include?(SiteSetting.default_locale)
      unless defined? RMMSeg
        require 'rmmseg'
        RMMSeg::Dictionary.load_dictionaries
      end

      algo = RMMSeg::Algorithm.new(search_data)

      data = ""
      while token = algo.next_token
        data << token.text << " "
      end
    end

    data.force_encoding("UTF-8")
    data
  end

  def initialize(term, opts=nil)
    if term.present?
      @term = Search.prepare_data(term.to_s)
      @original_term = PG::Connection.escape_string(@term)
    end
  end

  def self.execute(term, opts=nil)
    self.new(term, opts).execute
  end

  # Query a term
  def execute
  end
end
