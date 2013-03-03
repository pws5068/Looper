class Group < ActiveRecord::Base
  attr_accessible :alias

  has_many :shares
  has_many :group_users
  has_many :users, :through => :group_users

end