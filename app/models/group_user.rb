class GroupUser < ActiveRecord::Base
  has_many :users
  has_many :groups
  
  attr_accessible :group_id, :user_id
end
