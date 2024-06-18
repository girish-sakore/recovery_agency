class CreateUserPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :user_preferences do |t|
      t.references :admin_user, null: false, foreign_key: true
      t.text :column_preferences, array: true, default: []

      t.timestamps
    end
  end
end
