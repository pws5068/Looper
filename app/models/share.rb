class Share < ActiveRecord::Base
  has_many :tags
  belongs_to :group

  attr_accessible :url, :thumb, :title, :media_type, :description

end
