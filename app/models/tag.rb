class Tag < ActiveRecord::Base
  belongs_to :share

  attr_accessible :content_id, :keyword
end
