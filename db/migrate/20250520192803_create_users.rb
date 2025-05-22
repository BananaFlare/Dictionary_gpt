class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :email,           null: false, default: ""
      t.string  :password_digest, null: false
      t.boolean :enabled,         null: false, default: true
      t.integer :role,            null: false, default: 0
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
