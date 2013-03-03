class Group < ActiveRecord::Base
  attr_accessible :alias

  has_many :contents
  has_many :users, :through => :group_users
  has_many :tags, :through => :contents

end