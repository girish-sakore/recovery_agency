class AddRoleToAdminUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :role, :integer, default: 0
  end
end
