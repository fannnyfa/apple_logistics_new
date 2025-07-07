class Collection < ApplicationRecord
  belongs_to :market
  
  enum :status, { pending: 0, in_progress: 1, completed: 2 }
  
  validates :farm_name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :scheduled_at, presence: true
  
  scope :today, -> { where(scheduled_at: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :by_date, ->(date) { where(scheduled_at: date.beginning_of_day..date.end_of_day) }
  
  after_initialize :set_default_status, if: :new_record?
  
  def revert_to_pending!
    update!(status: :in_progress)
  end
  
  private
  
  def set_default_status
    self.status ||= :in_progress
  end
end
