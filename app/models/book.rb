class Book < ApplicationRecord
  STATUSES = [ "Available", "Checked Out", "Reserved" ].freeze

  validates :title, presence: true
  validates :author, presence: true
  validates :status, inclusion: { in: STATUSES }
end
