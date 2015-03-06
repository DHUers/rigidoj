class BasicSolutionSerializer < ActiveModel::Serializer
  attributes :id, :platform, :source, :revision

  has_one :problem, serializer: BasicProblemSerializer
end
