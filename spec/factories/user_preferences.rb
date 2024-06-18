FactoryBot.define do
  factory :user_preference do
    user_id { 1 }
    column_preferences { "MyText" }
  end
end
