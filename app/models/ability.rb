# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new
    if user.admin?
      can :manage, :all
    elsif user.caller?
      can :read, ActiveAdmin::Page, name: "Dashboard"
      can [:index, :read, :update], AllocationDraft, caller_id: user.id
    elsif user.executive?
      can :read, ActiveAdmin::Page, name: "Dashboard"
      can [:index, :read, :update], AllocationDraft, executive_id: user.id
    end
  end
end
