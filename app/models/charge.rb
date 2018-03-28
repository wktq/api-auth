class Charge < ApplicationRecord
  belongs_to :proposal

  validates :charge_id, presence: true
end
