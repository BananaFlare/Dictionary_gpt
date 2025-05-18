class CreateWords < ActiveRecord::Migration[8.0]
  def change
    create_table :words do |t|
      t.references :dictionary, null: false, foreign_key: true
      t.string :foreign_word
      t.string :transcription
      t.string :translation
      t.text :example

      t.timestamps
    end
  end
end
