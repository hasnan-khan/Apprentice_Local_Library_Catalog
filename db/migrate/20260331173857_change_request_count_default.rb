class ChangeRequestCountDefault < ActiveRecord::Migration[8.1]
  def change
    change_column_default :recommendations, :request_count, from: nil, to: 0
    Recommendation.where(request_count: nil).update_all(request_count: 0)
  end
end
