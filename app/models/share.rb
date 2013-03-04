class Share < ActiveRecord::Base
  has_many :tags
  has_many :share_views
  belongs_to :group

  attr_accessible :url, :thumb, :title, :media_type, :description
  attr_accessible :preview_html, :share_views, :group_id

  #validates :media_type, :inclusion => { :in => ['article', 'audio', 'video', 'photo'] }

  before_save :scrape_data

  def youtubeify( identifier )
    video = Share.get_youtube_video( identifier )
    if video
      title = video.title
      description = video.description
      thumb = video.thumbnails.first().url
      url = video.player_url
      preview_html = 
      "<iframe id='ytplayer' type='text/html' width='640' height='390'
  src='http://www.youtube.com/embed/#{identifier}?autoplay=1'
  frameborder='0'/>" # @todo - this should be calculated on the fly
      media_type = 'video'
    else
      false
    end
  end

  def self.parse_youtube_url url
    if url.nil?
      false
    else
      regex = /^(?:http:\/\/)?(?:www\.)?\w*\.\w*\/(?:watch\?v=)?((?:p\/)?[\w\-]+)/
      out = url.match(regex)
      if ! out.nil?
        out[1]
      else
        false
      end
    end
  end

  def viewers
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
  end

  def is_youtube?
    !! Share.parse_youtube_url( url )
  end

  private

  def scrape_data
    if is_youtube?
      media_type = 'video'
      identifier = Share.parse_youtube_url( url )
      youtubeify( identifier )
    end
  end

  def self.get_youtube_video(identifier)
    client = yt_session()
    begin
      video = client.video_by identifier
    rescue OpenURI::HTTPError
      false
    end
  end

  def self.yt_session
    # @todo - pull the following credentials out into a config file
    @yt_client ||= YouTubeIt::Client.new(
      :username => 'looper.io.app@gmail.com' , 
      :password => 'sincerely' , 
      :dev_key => 'AI39si5eqTcj26_n9Jjb_WsRfpy-xw0dOdWxMgUSmHtH3TSLmT_D2hTDQyJ-DHLRjfpxWJ1K65ccZe2N5x8Poj0Up0saky-TaQ' )
  end
end