class Pada < ApplicationRecord
  belongs_to :language
  belongs_to :dictionary

  ROOT_LANGUAGES = %w[
    ಸಂಸ್ಕೃತ ಪಾಳಿ ಪ್ರಾಕೃತ ಪಾರಸಿ ಅರಬಿಕ್ ಪೋರ್ಚುಗೀಸ್
    ಇಂಗ್ಲೀಷ್ ದ್ರಾವಿಡ ತಮಿಳು ತೆಲುಗು ಮಲಯಾಳಂ ತುಳು
    ದೇಶ್ಯ ತತ್ಸಮ ತದ್ಭವ ಅನ್ಯ
  ].freeze

  def self.search(word)
    word = word.unicode_normalize(:nfkc) if word
    left_joins(:dictionary).where(word: word)
  end

  def self.similar_search(word)
    word = word.unicode_normalize(:nfkc) if word
    where("word LIKE ?", "%#{word}%")
  end

  def self.search_by_meaning(word)
    word = word.unicode_normalize(:nfkc) if word
    where("meaning LIKE ?", "%#{word}%")
  end

  def self.exclude_word_ids(ids)
    return all if ids.blank?
    where.not(id: ids)
  end

end
