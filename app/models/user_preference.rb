class UserPreference < ApplicationRecord
  belongs_to :admin_user
  # serialize :column_preferences, JSON
  def column_preferences
    super || default_columns
  end

  private

  def default_columns
    ['id', 'customer_name']  # Add your default columns here
  end
end
