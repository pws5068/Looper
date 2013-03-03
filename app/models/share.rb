class Share < ActiveRecord::Base
  has_many :tags
  belongs_to :group

  attr_accessible :url, :thumb, :title, :media_type, :description
  attr_accessible :preview_html

  validates :media_type, :inclusion => { :in => ['article', 'audio', 'video', 'photo'] }
end