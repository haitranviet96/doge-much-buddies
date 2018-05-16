class Friend < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates_uniqueness_of :user_id, scope: :friend_id

  after_create_commit { FriendRequestBroadcastJob.perform_later(self) }

  def self.find_by_users(user_id, friend_id)
    where('user_id = ? AND friend_id = ?', user_id, friend_id).or(
           where('user_id = ? AND friend_id = ?', friend_id, user_id)
         )[0]
  end
end
