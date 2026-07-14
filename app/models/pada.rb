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

  def self.by_root_word(root_word)
    return none if root_word.blank?
    where(root_word: root_word).where.not(root_language: nil)
  end

  def self.cognates_for(root_word, exclude_id: nil)
    return none if root_word.blank?
    relation = where(root_word: root_word).where.not(root_language: nil)
    relation = relation.where.not(id: exclude_id) if exclude_id
    relation
  end

  def cognate_entries
    return Pada.none if root_word.blank?
    self.class.cognates_for(root_word, exclude_id: id)
  end

end
