class Ability
    include CanCan::Ability

    def initialize(user)
        # Define abilities for the passed in user here. For example:
        #
        #   user ||= User.new # guest user (not logged in)
        #   if user.admin?
        #     can :manage, :all
        #   else
        #     can :read, :all
        #   end
        #
        # The first argument to `can` is the action you are giving the user 
        # permission to do.
        # If you pass :manage it will apply to every action. Other common actions
        # here are :read, :create, :update and :destroy.
        #
        # The second argument is the resource the user can perform the action on. 
        # If you pass :all it will apply to every resource. Otherwise pass a Ruby
        # class of the resource.
        #
        # The third argument is an optional hash of conditions to further filter the
        # objects.
        # For example, here the user can only update published articles.
        #
        #   can :update, Article, :published => true
        #
        # See the wiki for details:
        # https://github.com/ryanb/cancan/wiki/Defining-Abilities

        user ||= User.new # guest user (not logged in)

        if user.role? :super_admin
            can :manage, :all
        end

        if user.role? :user_admin
            can :manage, [Cause, Merchant, Promotion, Donation, User]
            can :view_admin_menu, User
        end

        if user.role? :event_admin
            can :manage, [Event, Group]
            can :view_admin_menu, User
        end

        if user.role? :user
            # Merchant permissions
            can [:index, :create], Merchant
            can [:edit, :update, :delete, :show], Merchant do |merchant|
                merchant.users.include?(user)
            end
            # Promotion permissions
            can [:index, :create], Promotion
            can [:edit, :update, :delete, :show, :duplicate], Promotion do |promotion|
                promotion.merchant.users.include?(user)
            end
            # Single permissions
            can [:index, :create], Single
            can [:edit, :update, :delete, :show], Single do |single|
                single.users.include?(user)
            end
            # Donation permissions
            can [:index, :show], Donation do |donation|
                donation.users.include?(user)
            end

        end

    end
end
