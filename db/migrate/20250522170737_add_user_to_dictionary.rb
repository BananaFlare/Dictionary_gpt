class AddUserToDictionary < ActiveRecord::Migration[8.0]
  def change
    add_reference :dictionaries, :user, null: true, foreign_key: true
  end
end
