class BasicSolutionSerializer < ApplicationSerializer
  attributes :platform, :source, :revision

  has_one :problem, serializer: BasicProblemSerializer
end
