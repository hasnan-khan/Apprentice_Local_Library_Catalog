class RequestNote < ApplicationRecord
  belongs_to :recommendation, counter_cache: :request_count
  before_validation :set_default_patron_name
  validates :note_text, presence: true
  private
  def set_default_patron_name
    self.patron_name = "Patron" if patron_name.blank?
  end
end
