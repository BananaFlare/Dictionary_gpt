class CreateDictionaries < ActiveRecord::Migration[8.0]
  def change
    create_table :dictionaries do |t|
      t.string :link

      t.timestamps
    end
  end
end
