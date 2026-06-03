class JanaSanchayaVote < ApplicationRecord
  belongs_to :jana_sanchaya_entry
  
  validates :user_ip, presence: true
  validates :vote_type, presence: true, inclusion: { in: %w[up down] }
  validates :jana_sanchaya_entry_id, uniqueness: { scope: :user_ip }
end
