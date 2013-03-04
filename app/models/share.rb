class Share < ActiveRecord::Base
  has_many :tags
  has_many :share_views
  belongs_to :group

  attr_accessible :url, :thumb, :title, :media_type, :description
  attr_accessible :preview_html, :share_views

  validates :media_type, :inclusion => { :in => ['article', 'audio', 'video', 'photo'] }

  def self.from_youtube(identifier)
    video = get_youtube_video( identifier )
    if video
      share = Share.new()
      share.title = video.title
      share.description = video.description
      share.thumb = video.thumbnails.first().url
      share.url = video.player_url
      share.preview_html = 
      "<iframe id='ytplayer' type='text/html' width='640' height='390'
  src='http://www.youtube.com/embed/#{identifier}?autoplay=1'
  frameborder='0'/>" # @todo - this should be calculated on the fly
      share.media_type = 'video'
      share.save()
    else
      false
    end
  end

  private
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