class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :room_key, dependent: :destroy
  belongs_to :user
end
