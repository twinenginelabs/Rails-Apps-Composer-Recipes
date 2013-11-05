class Ability
  if defined?(CanCan)
    include CanCan::Ability
  end

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    
    if user.role?('Admin')
      can :manage, :all
    end
    
  end
end
