class CreateRequestNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :request_notes do |t|
      t.references :recommendation, null: false, foreign_key: true
      t.string :patron_name
      t.text :note_text

      t.timestamps
    end
  end
end
