class JanaSanchayaEntry < ApplicationRecord
  validates :word, presence: true
  validates :meaning, presence: true
  validates :status, inclusion: { in: %w[pending approved rejected] }, allow_blank: true

  belongs_to :dialect, optional: true

  has_many :jana_sanchaya_votes, dependent: :destroy

  scope :search, ->(word) { word = word.unicode_normalize(:nfkc) if word; where("word = ? OR meaning LIKE ?", word, "%#{word}%") }
  scope :similar_search, ->(word) { word = word.unicode_normalize(:nfkc) if word; where("word LIKE ? OR meaning LIKE ?", "%#{word}%", "%#{word}%") }
  scope :ranked, -> { order(votes_up: :desc, created_at: :desc) }
  scope :approved, -> { where(status: 'approved') }
  scope :dialect_entries, -> { where(is_dialect: true) }
  scope :by_dialect, ->(id_or_name) {
    if id_or_name.to_s.match?(/\A\d+\z/)
      where(dialect_id: id_or_name)
    else
      where(dialect_name: id_or_name)
    end
  }
  scope :by_ecological_domain, ->(domain) { where(ecological_domain: domain) }
  scope :by_root_language, ->(lang) { where(root_language: lang) }
  scope :by_current_place, ->(place) { where("current_place LIKE ?", "%#{place}%") }
  scope :by_dialect_place, ->(place) { where("dialect_place LIKE ?", "%#{place}%") }

  ECOLOGICAL_DOMAINS = %w[
    ಕೃಷಿ ಕಾಡು/ವನ ಜಲ ಸಸ್ಯ ಸಂಪತ್ತು ಪ್ರಾಣಿ ಸಂಪತ್ತು
    ಋತು/ಹವಾಮಾನ ಭೂಗೋಳ ಆಹಾರ ಆಚರಣೆ/ಸಂಸ್ಕೃತಿ
    ಸಂಪ್ರದಾಯಿಕ ಜ್ಞಾನ ವಾಸ್ತು/ನಿರ್ಮಾಣ ವ್ಯಾಪಾರ/ವಾಣಿಜ್ಯ
  ].freeze

  ROOT_LANGUAGES = %w[
    ಸಂಸ್ಕೃತ ಪಾಳಿ ಪ್ರಾಕೃತ ಪಾರಸಿ ಅರಬಿಕ್ ಪೋರ್ಚುಗೀಸ್
    ಇಂಗ್ಲೀಷ್ ದ್ರಾವಿಡ ತಮಿಳು ತೆಲುಗು ಮಲಯಾಳಂ ತುಳು
    ದೇಶ್ಯ ತತ್ಸಮ ತದ್ಭವ ಅನ್ಯ
  ].freeze

  POS_TYPES = %w[
    ನಾಮಪದ ಸರ್ವನಾಮ ಕ್ರಿಯಾಪದ ವಿಶೇಷಣ ಕ್ರಿಯಾವಿಶೇಷಣ
    ಉಪಸರ್ಗ ಸಮುಚ್ಚಯ ವಿಸ್ಮಯಾರ್ಥಕ ಅವ್ಯಯ
  ].freeze

  def vote_score
    votes_up - votes_down
  end

  def user_voted?(ip)
    jana_sanchaya_votes.exists?(user_ip: ip)
  end

  def user_vote(ip)
    jana_sanchaya_votes.find_by(user_ip: ip)
  end

  def upvote!(ip)
    return false if user_voted?(ip)
    transaction do
      jana_sanchaya_votes.create!(user_ip: ip, vote_type: 'up')
      update!(votes_up: votes_up + 1)
    end
    true
  end

  def downvote!(ip)
    return false if user_voted?(ip)
    transaction do
      jana_sanchaya_votes.create!(user_ip: ip, vote_type: 'down')
      update!(votes_down: votes_down + 1)
    end
    true
  end

  def remove_vote!(ip)
    vote = user_vote(ip)
    return false unless vote
    transaction do
      if vote.vote_type == 'up'
        update!(votes_up: [votes_up - 1, 0].max)
      else
        update!(votes_down: [votes_down - 1, 0].max)
      end
      vote.destroy!
    end
    true
  end
end
