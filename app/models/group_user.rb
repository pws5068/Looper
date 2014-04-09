class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  #attr_accessible :group,:group_id, :user_id
end
