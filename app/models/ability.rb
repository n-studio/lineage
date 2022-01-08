# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :edit, Practitioner, added_by: user
    can :delete, Practitioner, added_by: user

    return unless user.admin?

    can :edit, Practitioner
    can :delete, Practitioner
  end
end
