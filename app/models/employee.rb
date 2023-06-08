class Employee < ApplicationRecord
  belongs_to :store
  has_many :orders
  has_one_attached :picture

  def account_status
    User.find_by(email: self.email) ? true : false
  end
end
