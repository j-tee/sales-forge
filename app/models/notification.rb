class Notification < ApplicationRecord
    belongs_to :store
    validates :notification_type, presence: true
  validates :value, presence: true, numericality: { only_integer: true }
end
