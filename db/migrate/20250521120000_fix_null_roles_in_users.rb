class FixNullRolesInUsers < ActiveRecord::Migration[7.0]
  def up
    # Set default role to 0 (user) where role is null
    execute <<-SQL.squish
      UPDATE users
      SET role = 0
      WHERE role IS NULL
    SQL
  end

  def down
    # No rollback needed
  end
end
