class SearchProblemSerializer < ApplicationSerializer
  attributes :blurb
  def blurb
    options[:result].blurb(object)
  end
end
