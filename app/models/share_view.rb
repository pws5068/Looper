class ShareView < ActiveRecord::Base
  has_many :users
  has_many :shares
end
