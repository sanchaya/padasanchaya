class WiktionaryEntry < ApplicationRecord
  validates :word, presence: true

  def self.search(word)
    where(word: word)
  end

  def self.similar_search(word)
    where("word LIKE ?", "%#{word}%")
  end
end
