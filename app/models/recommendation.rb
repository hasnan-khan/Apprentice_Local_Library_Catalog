class Recommendation < ApplicationRecord
  has_many :request_notes, dependent: :destroy
  validates :title, :author, presence: true
  enum :status, { requested: "requested", ordered: "ordered", received: "received", catalogued: "catalogued" }, default: "requested"
end
