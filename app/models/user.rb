class User < ApplicationRecord
  # Include default devise modules. Others available are:
  has_merit
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :recoverable, :rememberable, :trackable, :timeoutable,
         :omniauthable, omniauth_providers: [:github, :google_oauth2, :twitter]

  acts_as_voter
  acts_as_follower
  acts_as_followable

  has_many :posts
  has_many :comments
  has_many :events

  has_many :friends
  has_many :all_received_friend_requests,
           class_name: "Friend",
           foreign_key: "friend_id"

  has_many :accepted_sent_friend_requests, -> { where(friends: { accepted: true}) },
           through: :friends,
           source: :friend
  has_many :accepted_received_friend_requests, -> { where(friends: { accepted: true}) },
           through: :all_received_friend_requests,
           source: :user
  has_many :pending_sent_friend_requests, ->  { where(friends: { accepted: false}) },
           through: :friends,
           source: :friend
  has_many :pending_received_friend_requests, ->  { where(friends: { accepted: false}) },
           through: :all_received_friend_requests,
           source: :user

  # gets all your friends
  def all_active_friends
    accepted_sent_friend_requests | accepted_received_friend_requests
  end

  # gets your pending sent and received friends
  def pending_friends
    pending_sent_friend_requests | pending_received_friend_requests
  end

  # gets a friend record
  def friend(friend)
    friend.where(user_id: self.id, friend_id: friend.id)[0]
  end

  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, AvatarUploader

  validates_presence_of :name

  self.per_page = 10

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def self.create_from_provider_data(provider_data)
    if where(email: provider_data.info.email).first.nil?
      where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
        user.name = provider_data.info.name
        user.email = provider_data.info.email
        user.location = provider_data.info.location
        user.about = provider_data.extra.raw_info.description
        if provider_data.info.image.present?
          user.remote_avatar_url = provider_data.info.image
        end
        if provider_data.extra.raw_info.profile_banner_url.present?
          user.remote_cover_url = provider_data.extra.raw_info.profile_banner_url
        end
        user.password = Devise.friendly_token[0, 20]
        user.save!
      end
    else
      where(email: provider_data.info.email).first
    end
  end
end
