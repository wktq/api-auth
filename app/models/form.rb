class Form < ApplicationRecord
  belongs_to :user

  has_many :fields, dependent: :destroy
end
