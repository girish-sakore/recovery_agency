class AllocationDraft < ApplicationRecord
  belongs_to :caller, class_name: 'AdminUser', optional: true
  belongs_to :executive, class_name: 'AdminUser', optional: true

  before_save :update_caller_name

  private

  def update_caller_name
    self.caller_name = caller.display_name if caller_id_changed? && caller
  end
end
