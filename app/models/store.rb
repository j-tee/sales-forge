class Store < ApplicationRecord
  belongs_to :user
  has_many :stocks
  has_many :notifications
end
