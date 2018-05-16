class FriendRequestBroadcastJob < ApplicationJob
  queue_as :default

  def perform(friend_request)

    sender = User.find(friend_request.user_id)
    receiver = User.find(friend_request.friend_id)
    ActionCable.server.broadcast(
        "notifications_#{receiver.id}",
        notification: 'friend-request-received',
        sender_user_name: sender.name,
        friend_request: render_friend_request(sender, friend_request)
    )

  end

  private

  def render_friend_request(sender, friend_request)
    ApplicationController.render(
        partial: 'friends/friend_request',
        locals: { sender: sender }
    )
  end

end