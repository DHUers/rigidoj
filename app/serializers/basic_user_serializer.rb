class BasicUserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name, :avatar_url

  def avatar_url
    ''
  end

end
