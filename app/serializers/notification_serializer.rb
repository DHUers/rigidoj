class NotificationSerializer < ActiveModel::Serializer
  has_one :solution
  has_one :contest
  has_one :problem

  attributes :data, :read, :notification_type
end
