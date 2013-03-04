class Group < ActiveRecord::Base
  has_many :shares
  has_many :group_users
  has_many :users, :through => :group_users

  attr_accessible :alias, :users

  # @todo - Mega Hackish
  def self.find_or_create( users )
    user_ids = users.collect(&:id)

    for group in users.first().groups
      g_users = group.users

      if g_users.count == user_ids.count
        valid = true
        for user in g_users
          if !user_ids.include?(user.id)
            valid = false
          end
        end
        if valid
          match = group
          break
        end
      end
    end

    if !match
      group = Group.create()
      for user in users
        GroupUser.create( :user_id => user.id, :group_id => group.id )
      end
    else
      group = match
    end
    group
  end
end
