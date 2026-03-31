class CreateRecommendations < ActiveRecord::Migration[8.1]
  def change
    create_table :recommendations do |t|
      t.string :title
      t.string :author
      t.string :status
      t.integer :request_count

      t.timestamps
    end
  end
end
