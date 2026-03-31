class Book < ApplicationRecord
  STATUSES = [ "Available", "Checked Out", "Reserved" ].freeze

  validates :title, presence: true
  validates :author, presence: true
  validates :status, inclusion: { in: STATUSES }

  # Filter scopes
  scope :title_contains, ->(term) { where("title LIKE ?", "%#{term}%") }
  scope :author_contains, ->(term) { where("author LIKE ?", "%#{term}%") }
end
