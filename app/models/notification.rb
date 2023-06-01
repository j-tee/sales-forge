class Notification < ApplicationRecord
    belongs_to :store
    validates :type, presence: true
  validates :value, presence: true, numericality: { only_integer: true }
end
