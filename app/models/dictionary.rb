class Dictionary < ApplicationRecord
  has_many :padas, dependent: :nullify

  validates :name, presence: true
end
