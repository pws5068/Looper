class User < ActiveRecord::Base

  has_many :group_users
  has_many :groups, :through => :group_users
  has_many :accessible_shares, :through => :groups, :source => :shares
  #has_many :shares, :through => :share_views

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :thumb_url, :icon_url, :uid

  def fb_friends
    graph = facebook()
    facebook().get_connection('me','friends') if graph
  end

  def self.find_or_create_from_facebook( data )
    user = User.where("uid='#{data['id']}'").first()

    unless user
      User.create({
        :uid => data['id'], 
        :name => data['name'], 
        :thumb_url => "http://graph.facebook.com/#{data['id']}/picture",
        :provider => 'facebook'
        }, without_protection: true)
    end
  end

  def fb_connected?
    oauth_token.present?
  end

  def friends
    User.where("id != #{id}") # todo -- this function should return users that i'm in groups with
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
      user.email = auth.info.email
      user.name = auth.info.name
      # @todo - why is this breaking in prod?
      #user.icon_url = "http://graph.facebook.com/#{auth.uid}/picture"
      user.thumb_url = "http://graph.facebook.com/#{auth.uid}/picture"
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    end
  end

  def self.new_with_session(params, session)
    if session and session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def email_required?
    super && uid.blank?
  end

  def password_required?
    super && uid.blank?
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end
end
