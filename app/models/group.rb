class Group < ActiveRecord::Base
  has_many :shares
  has_many :group_users
  has_many :users, :through => :group_users

  attr_accessible :alias, :users

  def self.find_or_create current_user, friends # Let rails take care of the validation if they are already in the group or not
    current_user.groups.each do |group|
      group.group_users.create(user_ids: friends.map(&:id))
    end
  end

end
