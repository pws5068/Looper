class ShareView < ActiveRecord::Base
  belongs_to :user
  belongs_to :share

  #attr_accessible :share_id, :user_id

  def self.by_group(group_id)
    ShareView.where('group_id=#{group_id}')
  end

end