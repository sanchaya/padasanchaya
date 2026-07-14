class WiktionaryEntry < ApplicationRecord
  validates :word, presence: true

  def self.search(word)
    word = word.unicode_normalize(:nfkc) if word
    where(word: word)
  end

  def self.similar_search(word)
    word = word.unicode_normalize(:nfkc) if word
    where("word LIKE ?", "%#{word}%")
  end
end
