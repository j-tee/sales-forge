class UsersRoleSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :role_id
  attribute :role_name do |user_role|
    user_role.name
  end

  attribute :user_name do |user_role|
    user_role.user_name
  end
end
