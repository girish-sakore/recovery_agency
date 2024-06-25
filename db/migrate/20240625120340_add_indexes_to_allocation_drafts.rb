class AddIndexesToAllocationDrafts < ActiveRecord::Migration[7.1]
  def change
    # add_index :allocation_drafts, :caller_id
    # add_index :allocation_drafts, :executive_id
    add_index :allocation_drafts, :created_at
    add_index :allocation_drafts, :updated_at
    add_index :allocation_drafts, :agreement_id
    add_index :allocation_drafts, :customer_name
    add_index :allocation_drafts, :ptp_date
    
    # Composite index for common query combinations
    add_index :allocation_drafts, [:caller_id, :created_at]
    add_index :allocation_drafts, [:executive_id, :created_at]
  end
end
