class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  def user_name
    user.username
  end

  def role_name
    role.name
  end
end
