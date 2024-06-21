class AddCallerAndExecutiveToAllocationDrafts < ActiveRecord::Migration[7.1]
  def change
    add_reference :allocation_drafts, :caller, null: true, foreign_key: { to_table: :admin_users }
    add_reference :allocation_drafts, :executive, null: true, foreign_key: { to_table: :admin_users }
  end
end
