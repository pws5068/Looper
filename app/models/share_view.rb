class ShareView < ActiveRecord::Base
  belongs_to :user
  belongs_to :share
end
