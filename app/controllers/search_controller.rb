require_dependency 'search'

class SearchController < ApplicationController
  def query
    params.require(:term)

    search_args = {}
    if params[:include_blurbs].present?
      search_args[:include_blurbs] = params[:include_blurbs] == "true"
    end
    search_args[:search_for_id] = true if params[:search_for_id].present?

    search = Search.new(params[:term], search_args.symbolize_keys)
    result = search.execute
    render json: result
  end


end
