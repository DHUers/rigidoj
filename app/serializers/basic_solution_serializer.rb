class BasicSolutionSerializer < ActiveModel::Serializer
  attributes :id, :platform, :source, :revisiongs

  has_one :problem, serializer: BasicProblemSerializer
end
