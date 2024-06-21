class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  enum role: { caller: 0, executive: 1, admin: 2 }

  has_one :user_preference

  validates :name, presence: true, if: :name_required?

  def display_name
    name.presence || email
  end

  private

  def name_required?
    caller? || executive?
  end
end
