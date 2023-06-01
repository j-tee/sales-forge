class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :created_at, :username, :avatar
  attribute :created_date do |user|
    user.created_at && user.created_at.strftime('%m/%d/%Y')
  end

  attribute :image_url do |user|
    if user.avatar.attached?
      {
        url: rails_blob_url(user.avatar)
      }
    end
  end
end