class Share < ActiveRecord::Base
  has_many :tags
  has_many :share_views
  belongs_to :group

  attr_accessible :url, :thumb, :title, :media_type, :description
  attr_accessible :preview_html, :share_views, :group_id

  #validates :media_type, :inclusion => { :in => ['article', 'audio', 'video', 'photo'] }

  before_save :scrape_data

  def youtubeify
    video = get_video_details()
    if video
      self.title = video.title
      self.description = video.description
      self.thumb = video.thumbnails.first().url
      self.url = video.player_url
      self.preview_html = video.embed_html5()
      self.media_type = 'video'
    else
      false
    end
  end

  def soundcloudify
    track = get_audio_details()
    if track
      self.title = track.title
      self.description = track.description
      self.url = track.permalink_url
      self.thumb = track.artwork_url
      track.preview_html = 
        "<iframe width='100%' height='166' scrolling='no' frameborder='no' src='https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F#{track.id}'></iframe>"
    else
      false
    end
  end

  def self.parse_youtube_url url
    if ! url.nil?
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

  def is_valid_youtube?
     !! get_video_details() # probably shouldnt make these calls twice
  end

  def is_valid_audio?
    !! get_audio_details()
  end

  def get_video_details
    client = Share.yt_session()
    begin
      client.video_by( url ) 
    rescue OpenURI::HTTPError
      false
    end
  end

  def get_audio_details
    client = Share.sc_session()
    track = client.get('/resolve', :url => url)
  end

  private

  def scrape_data
    if is_valid_youtube?
      self.media_type = 'video'
      youtubeify()
    elsif is_valid_audio?
      self.media_type = 'audio'
      soundcloudify()
    end
  end

  def self.yt_session
    # @todo - pull the following credentials out into a config file
    @yt_client ||= YouTubeIt::Client.new(
      :username => 'looper.io.app@gmail.com' , 
      :password => 'sincerely' , 
      :dev_key => 'AI39si5eqTcj26_n9Jjb_WsRfpy-xw0dOdWxMgUSmHtH3TSLmT_D2hTDQyJ-DHLRjfpxWJ1K65ccZe2N5x8Poj0Up0saky-TaQ' )
  end

  # Soundcloud
  def self.sc_session
    client = Soundcloud.new(:client_id => '64ef72bdca117ec1660e6b29124b1fc6')
  end
end