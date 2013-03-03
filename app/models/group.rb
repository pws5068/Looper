class Group < ActiveRecord::Base
  has_many :shares
  has_many :group_users
  has_many :users, :through => :group_users

  attr_accessible :alias, :users

end