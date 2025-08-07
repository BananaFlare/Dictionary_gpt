class AddTempToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :temp, :boolean
  end
end
