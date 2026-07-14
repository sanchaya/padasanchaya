class Dictionary < ApplicationRecord
  has_many :padas, dependent: :nullify

  validates :name, presence: true

  def show_name_in_search?
    show_name_in_search.present? && show_name_in_search == true
  end
end
