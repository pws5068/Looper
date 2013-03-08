class Share < ActiveRecord::Base
  has_many :tags
  has_many :share_views
  belongs_to :group

  attr_accessible :url, :thumb, :title, :media_type, :description
  attr_accessible :preview_html, :share_views, :group_id

  #validates :media_type, :inclusion => { :in => ['article', 'audio', 'video', 'photo'] }

  before_save :scrape_data

  def embedly
    client = Embedly::API.new :key => 'e8d4e74f0400420fa8a38df5d50fe26a',
        :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; paulsilvis@gmail.com)'
    obj = client.oembed :url => url
    json_obj = JSON.pretty_generate(obj[0].marshal_dump)

    if obj[0]
      obj = obj[0]
      self.title = obj.title
      self.description = obj.description
      self.preview_html = obj.html
      self.url = obj.url
      self.thumb = obj.thumbnail_url
      self.media_type = obj.type
    end
  end

  def viewers
    if ! group.nil?
      viewers = []
      users = group.users
      for user in users
        usr = user.attributes
        usr[:viewed] = 0
        for view in share_views
          if user.id == view.user_id
            usr[:viewed] = 1
          end
        end
        viewers << usr
      end
      viewers
    else
      []
    end
  end

  private

  def scrape_data
    embedly()
  end
end