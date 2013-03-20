class Share < ActiveRecord::Base
  has_many :tags
  has_many :share_views
  belongs_to :group

  attr_accessible :url, :thumb, :title, :media_type, :description
  attr_accessible :preview_html, :share_views, :group_id

  #validates :media_type, :inclusion => { :in => ['article', 'audio', 'video', 'photo'] }

  before_save :scrape_data

  def embedly
    obj = client.oembed :url => url
    unless obj.error_code
      obj = obj[0]
      self.title = obj.title
      self.description = obj.description
      self.preview_html = obj.html
      self.url = obj.url
      self.thumb = obj.thumbnail_url
      self.media_type = obj.type
    end
  end
  alias :scrape :embedly # Not sure why you are defining a method that just calls another but you can do this

  #def viewers ## Make smaller methods. I am extremely confused
    #if ! group.nil?
      #viewers = []
      #users = group.users
      #for user in users
        #usr = user.attributes
        #usr[:viewed] = 0
        #for view in share_views
          #if user.id == view.user_id
            #usr[:viewed] = 1
          #end
        #end
        #viewers << usr
      #end
      #viewers
    #else
      #[]
    #end
  #end

  def viewers # I think all you want is if a user has viewed a share which is represented in the share_views column return them
    share_views.map do |view|
      view.user
    end
  end


private

  def client
    @client ||= Embedly::API.new :key => 'e8d4e74f0400420fa8a38df5d50fe26a',
                                 :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; paulsilvis@gmail.com)'
  end
end
