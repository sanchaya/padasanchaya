class Dialect < ApplicationRecord
  validates :english_name, presence: true, uniqueness: true
  validates :kannada_name, presence: true, uniqueness: true

  scope :by_category, ->(cat) { where(category: cat) }
  scope :alphabetical, -> { order(:english_name) }

  CATEGORIES = %w[Regional Community Tribal].freeze

  def display_name
    "#{kannada_name} (#{english_name})"
  end
end
