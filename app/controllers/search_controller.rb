require_dependency 'search'

class SearchController < ApplicationController
  def query
    params.require(:term)

    search = Search.new(params[:term], search_args.symbolize_keys)
    result = search.execute
  end
end
