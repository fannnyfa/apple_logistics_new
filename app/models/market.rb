class Market < ApplicationRecord
  has_many :collections, dependent: :destroy
  
  validates :name, presence: true
  validates :location, presence: true
  validates :district, presence: true, inclusion: { in: %w[엄궁동 반여동] }
end
