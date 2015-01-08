require 'grouped_search_results'

class Search
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

    @opts = opts || {}
    @user = opts[:user] || nil
    @search_context = @opts[:search_context]
    @include_blurbs = @opts[:include_blurbs] || false
    @limit = Search.per_facet

    if @opts[:type_filter].present?
      @limit = Search.per_filter
    end

    @results = GroupedSearchResults.new(@opts[:type_filter], term, @search_context, @include_blurbs)
  end

  def self.execute(term, opts=nil)
    self.new(term, opts).execute
  end

  # Query a term
  def execute
    if @opts[:search_for_id] && @results.type_filter == 'problem'
      find_single_problem
    end

    @results
  end

  private

  def find_single_problem
    if @term =~ /^\d+$/
      single_problem(@term.to_i)
    else
      begin
        route = Rails.application.routes.recognize_path(@term)
        single_problem(route[:problem_id]) if route[:problem_id].present?
      rescue ActionController::RoutingError
      end
    end
  end

  def single_problem(id)
    problem = Problem.find(id)
    return nil unless ProblemPolicy.new(@user, problem).show?

    @results.add(problem)
    @results
  end
end
