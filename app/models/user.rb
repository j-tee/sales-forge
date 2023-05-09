class User < ApplicationRecord
  rolify
  has_many :stores
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :confirmable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  require 'devise/async'
  # Use async to send confirmation and password reset emails
  devise :async

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  attribute :password_confirmation, :string

  validates_confirmation_of :password
end
