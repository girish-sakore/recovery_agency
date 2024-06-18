class UserPreference < ApplicationRecord
  belongs_to :admin_user
  # serialize :column_preferences, JSON
end
