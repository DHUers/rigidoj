class GroupedSearchResultSerializer < ApplicationSerializer
  #has_many :posts, serializer: BasicPostSerializer
  #has_many :users, serializer: BasicUserSerializer
  has_many :problems, serializer: SearchProblemSerializer
  #has_many :contests, serializer: BasicContestSerializer
  attributes :more_posts, :more_users, :more_problems, :more_contests
end
