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
